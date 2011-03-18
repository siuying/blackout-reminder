//
//  BlackoutViewController.m
//  Blackout
//
//  Created by Francis Chong on 11Âπ¥3Êúà16Êó•.
//  Copyright 2011Âπ¥ Ignition Soft Limited. All rights reserved.
//

#import "BlackoutViewController.h"
#import "BlackoutAppDelegate.h"

@implementation BlackoutViewController

@synthesize btnPrefecture, btnCity, btnStreet;
@synthesize lblTimeTitle, lblTimeRemaining, lblTimeDetail, lblLastUpdate;
@synthesize buttonWarning, buttonHomepage, navigationBar;
@synthesize locationService, blackoutService;
@synthesize selectedPrefecture, selectedCity, selectedStreet;
@synthesize timeTitle;

- (void)dealloc
{
    self.locationService = nil;
    self.blackoutService = nil;
    self.selectedCity = nil;
    self.selectedPrefecture = nil;
    self.selectedStreet = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.blackoutService = [[[DummyBlackoutService alloc] init] autorelease];
    self.locationService = [[[LocationService alloc] init] autorelease];
    self.timeTitle = [[[RemaingTimeTitleView alloc]init]autorelease];
    self.locationService.locationDelegate = self;
    
    if (USE_MOCK_LOCATION) {
        // TODO Change hardcode logic to use more sources
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(35.661236, 139.558103);
        [self.locationService findLocationName:location];

    } else {
        // TODO
        // * check if CoreLocation service is enabled
        // * if not enabled, show alert and ask for Prefecture input
        // * if enabled, use CoreLocation service to find location
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.btnPrefecture = nil;
    self.btnCity = nil;
    self.btnStreet = nil;
    
    self.lblTimeDetail = nil;
    self.lblTimeRemaining = nil;
    self.lblTimeTitle = nil;
    self.buttonWarning = nil;
    self.buttonHomepage = nil;
    self.navigationBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) viewWillAppear:(BOOL)animated {
    
    UINavigationItem *barItem = [[UINavigationItem alloc]init];
    [timeTitle lastUpdatedTime:blackoutService.lastUpdated];
    barItem.titleView = timeTitle;
    [navigationBar pushNavigationItem:barItem animated:NO];
    [barItem release];
}


#pragma mark - LocationServiceDelegate

-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names {
    if (names && [names count] == 3) {
        NSLog(@" location found: %@", names);
        [self locationDidSelectedWithPrefecture:[names objectAtIndex:0]
                                           city:[names objectAtIndex:1]
                                         street:[names objectAtIndex:2]];
    }
}

-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error {
    // report error
    // ask for retry
}

#pragma mark - User Actions

-(IBAction) clickPrefecture:(id)sender {
    NSLog(@" clicked prefecture");
    [self promptInputWithSelectedPrefecture:nil city:nil street:nil];
}

-(IBAction) clickCity:(id)sender {
    NSLog(@" clicked city");
    [self promptInputWithSelectedPrefecture:self.selectedPrefecture city:nil street:nil];
}

-(IBAction) clickStreet:(id)sender {
    NSLog(@" clicked street");
    [self promptInputWithSelectedPrefecture:self.selectedPrefecture city:self.selectedCity street:nil];
}

-(IBAction) openWarning:(id)sender {
    NSLog(@" clicked warning button");
    RemarksViewController *controller = [[RemarksViewController alloc]init];
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navController animated:NO];
    [controller release];
}

-(IBAction) openTepcoUrl:(id)sender{
    NSLog(@" clicked TEPCO web button");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Safariを起動します" message:@"東京電力のページに移動します。宜しいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"はい", nil];
    
    [alert show];
    [alert release];
}

#pragma mark - Public

// prompt for user to input
-(void) promptInputWithSelectedPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    // TODO if user clicked city/street, should keep selected prefecture/city
    
    PrefectureTableViewController* pController = [[PrefectureTableViewController alloc] initWithBlackoutServices:self.blackoutService delegate:self];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:pController];
    [self presentModalViewController:navController animated:YES];
    [pController release];
    [navController release];
}

// asynchronously find current location, then set the prefecture, city and street
// if failed, as for retry or manual override
-(void) selectCurrentLocation {
    // TODO
    // Use CoreLocation to find current location
    // Find if there are matched Prefecture/City/Street
}

// update reminder time based on next currently input prefecture, city and street
-(void) refreshReminder {
    NSArray* blackoutPeriods = [self.blackoutService periodWithPrefecture:self.selectedPrefecture 
                                                                     city:self.selectedCity
                                                                   street:self.selectedStreet];
    if ([blackoutPeriods count] == 0) {
        // TODO show alert dialog for error finding period, ask user to select another prefecture
    } else {
        // more than one period, should find the next period
        NSDate* currentTime = [NSDate date];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *currentComponent = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:currentTime];
        
        BlackoutPeriod* period = [BlackoutUtils nextBlackoutWithCurrentTime:currentTime
                                                                    periods:blackoutPeriods];
        

        
        BOOL isBlackout = [BlackoutUtils isBlackout:currentTime period:period];
        
        if (isBlackout) {
            
            int currentTotalMinute = ([currentComponent hour] *60) + [currentComponent minute];
            int blackoutFromMinute = ([period.toTime hour] * 60) + [period.toTime minute];
            
            int remainMinuteForBlackout = blackoutFromMinute - currentTotalMinute;
            
            int hourEndBlackout = remainMinuteForBlackout / 60;
            int minuteEndBlackOut = remainMinuteForBlackout % 60;
            
            lblTimeTitle.text = [NSString stringWithFormat:@"停電が終わるまで"];
            
            lblTimeRemaining.text = [NSString stringWithFormat:@"%d時間%02d分", hourEndBlackout, minuteEndBlackOut];
            
            lblTimeDetail.text = [NSString stringWithFormat:@"計画停電時間：%02d:%02d - %02d:%02d",[period.fromTime hour],[period.fromTime minute],
                                                                                     [period.toTime hour],[period.toTime minute] ];
        } else {

            lblTimeTitle.text = [NSString stringWithFormat:@"計画停電まで"];
            
            lblTimeDetail.text = [NSString stringWithFormat:@"計画停電時間：%02d:%02d - %02d:%02d",[period.fromTime hour],[period.fromTime minute],
                                  [period.toTime hour],[period.toTime minute] ];
            
            int currentTotalMinute = ([currentComponent hour] *60) + [currentComponent minute];
            int blackoutFromMinute = ([period.fromTime hour] * 60) + [period.fromTime minute];
            
            int remainMinuteToBlackout = blackoutFromMinute - currentTotalMinute;
            
            if (remainMinuteToBlackout >= 0) {
                
                int hourToBlackout = remainMinuteToBlackout / 60;
                int minuteToBlackOut = remainMinuteToBlackout % 60;
                
                lblTimeRemaining.text = [NSString stringWithFormat:@"%d時間%02d分", hourToBlackout, minuteToBlackOut];
            } else {
                
                int currentTotalMinute2 = (24 * 60) - [currentComponent minute] - ([currentComponent hour] *60);
                int blackoutFromMinute2 = ([period.fromTime hour] * 60) + [period.fromTime minute];
                                                
                int remainMinuteToBlackout2 = currentTotalMinute2 + blackoutFromMinute2;
                
                int hourToBlackout = remainMinuteToBlackout2 / 60;
                int minuteToBlackOut = remainMinuteToBlackout2 % 60;
                
                lblTimeRemaining.text = [NSString stringWithFormat:@"%d時間%02d分", hourToBlackout, minuteToBlackOut];
                
            }

        }
        
//        UINavigationItem *barItem = [[UINavigationItem alloc]init];
//        [timeTitle lastUpdatedTime:blackoutService.lastUpdated];
//        barItem.titleView = timeTitle;
//        [navigationBar pushNavigationItem:barItem animated:NO];
//        [barItem release];
        
    }

}

#pragma mark LocationTableViewControllerDelegate

-(void) locationDidSelectedWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {    
    [self.btnPrefecture setTitle:prefecture forState:UIControlStateNormal];
    [self.btnCity setTitle:city forState:UIControlStateNormal];
    [self.btnStreet setTitle:street forState:UIControlStateNormal];
    [self refreshReminder];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) locationDidCancelled {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSLog(@"Open url in Safari");
        NSString* launchUrl = @"http://www.tepco.co.jp";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    }
    
}

@end
