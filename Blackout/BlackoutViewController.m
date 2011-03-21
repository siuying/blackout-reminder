//
//  BlackoutViewController.m
//  Blackout
//
//  Created by Francis Chong on 11Âπ¥3Êúà16Êó•.
//  Copyright 2011Âπ¥ Ignition Soft Limited. All rights reserved.
//

#import "BlackoutViewController.h"
#import "BlackoutAppDelegate.h"
#import "RemoteBlackoutService.h"

@interface BlackoutViewController (Private)
-(void) refreshReminderDidUpdatedWithGroups:(NSArray*)blackoutGroups periods:(NSArray*)blackoutPeriods;
@end

@implementation BlackoutViewController

@synthesize btnPrefecture, btnCity, btnStreet;
@synthesize lblTimeTitle, lblTimeRemaining, lblTimeDetail;
@synthesize buttonWarning, buttonHomepage, boNavigationBar;
@synthesize locationService, blackoutService;
@synthesize selectedPrefecture, selectedCity, selectedStreet;
@synthesize timeTitleView, progressView;
@synthesize groups, periods, lastUpdated;
@synthesize alertOn = _alertOn;

- (void)dealloc
{
    self.locationService = nil;
    self.blackoutService = nil;

    self.selectedCity = nil;
    self.selectedPrefecture = nil;
    self.selectedStreet = nil;

    self.groups = nil;
    self.periods = nil;
    self.lastUpdated = nil;
    
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

    // initialize services
    self.blackoutService = [[[RemoteBlackoutService alloc] init] autorelease];
    self.locationService = [[[LocationService alloc] init] autorelease];
    self.locationService.locationDelegate = self;

    self.btnPrefecture.titleLabel.lineBreakMode = UILineBreakModeClip;
    self.btnCity.titleLabel.lineBreakMode = UILineBreakModeClip;
    self.btnStreet.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    //Load persisted Prefecture, City and Street
    self.selectedPrefecture = [BlackoutAppDelegate displayPrefecture];
	self.selectedCity = [BlackoutAppDelegate displayCity];
	self.selectedStreet = [BlackoutAppDelegate displayStreet];
    
    [self.btnPrefecture setTitle:self.selectedPrefecture forState:UIControlStateNormal];
    [self.btnStreet setTitle:self.selectedStreet forState:UIControlStateNormal];
    [self.btnCity setTitle:self.selectedCity forState:UIControlStateNormal];
    
    // setup navigation bar
    self.timeTitleView = [[[RemaingTimeTitleView alloc]init]autorelease];
    UINavigationItem *barItem = [[UINavigationItem alloc]init];
    [self.timeTitleView lastUpdatedTime:blackoutService.lastUpdated];
    barItem.titleView = self.timeTitleView;
    [boNavigationBar pushNavigationItem:barItem animated:NO];
    [barItem release];
    
    //NSTimer to refresh time 
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];

    // begin finding location
    if (USE_MOCK_LOCATION) {
        [self setLoading:YES];

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(35.661236, 139.558103);
        [self.locationService findLocationName:location];

    } else {
        if ([CLLocationManager locationServicesEnabled]) {
            // location service is enabled
            // find current location
            [self.locationService findLocation];
            [self setLoading:YES];
            
        } else {
            // location service is NOT enable
            // show alert dialog to warn user about it and ask user manual select
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置情報" message:@"位置情報機能を起動するか、マニュアルで位置情報を入力してください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil];
            alert.tag = kAlertViewTwo;
            [alert show];
    }

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
    
    self.timeTitleView = nil;
    self.progressView = nil;

    self.buttonWarning = nil;
    self.buttonHomepage = nil;
    self.boNavigationBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - LocationServiceDelegate

-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names {
    if (names && [names count] == 3) {
        // TODO
        // If the location name is not in area affected of japan, show error and ask for manual selection

        NSLog(@" location name found: %@", names);
        [self locationDidSelectedWithPrefecture:[names objectAtIndex:0]
                                           city:[names objectAtIndex:1]
                                         street:[names objectAtIndex:2]];
        
        
    } else {
        NSLog(@" unexpected: %@", names);
        // TODO
        // no location found, show error message and ask user manual selection
        [self locationDidSelectedWithPrefecture:nil
                                           city:nil
                                         street:nil];
        if (!_alertOn) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置情報" message:@"マニュアルで位置情報を入力してください。" delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil];
            alert.tag = kAlertViewTwo;
            [alert show];
            _alertOn = YES;
        }
    }

    [self.locationService stop];
    [self setLoading:NO];
}

-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error {
    NSLog(@" error finding location name: %@", error);
    [self.locationService stop];
    [self setLoading:NO];

    // report error
    // ask for retry
}



-(void) findLocationDidFailedWithError:(NSError*)error {
    NSLog(@" error finding location name: %@", error);
    [self.locationService stop];
    [self setLoading:NO];
    
    // report error
    // ask for retry
}

#pragma mark - User Actions

-(IBAction) clickPrefecture:(id)sender {
    NSLog(@" clicked prefecture");
    [self promptInputWithSelectedPrefecture:nil city:nil street:nil];
}

-(IBAction) clickCity:(id)sender {
    NSLog(@" clicked city: %@", self.selectedPrefecture);
    [self promptInputWithSelectedPrefecture:self.selectedPrefecture city:nil street:nil];
}

-(IBAction) clickStreet:(id)sender {
    NSLog(@" clicked street:%@, %@", self.selectedPrefecture, self.selectedCity);
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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Safariを起動します" message:@"東京電力のページに移動します。\n宜しいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"はい", nil];
    alert.tag = kAlertViewOne;
    [alert show];
    [alert release];
}

#pragma mark - Public

// prompt for user to input
-(void) promptInputWithSelectedPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    // build nav controller & prefecture controller
    PrefectureTableViewController* pController = [[PrefectureTableViewController alloc] initWithBlackoutServices:self.blackoutService 
                                                                                                        delegate:self];   
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:pController];
    
    
    // build city controller if needed
    if (prefecture != nil) {
        CityTableViewController* cController = [[[CityTableViewController alloc] initWithBlackoutServices:self.blackoutService
                                                                                               prefecture:prefecture 
                                                                                                 delegate:self] autorelease];
        [navController pushViewController:cController animated:NO];
    }
    
    // build street controller if needed
    if (prefecture != nil && city != nil) {
        StreetTableViewController* sController = [[[StreetTableViewController alloc] initWithBlackoutServices:self.blackoutService 
                                                                                                  prefecture:prefecture 
                                                                                                        city:city 
                                                                                                    delegate:self] autorelease];
        [navController pushViewController:sController animated:NO];
    }
    
    [self presentModalViewController:navController animated:YES];
    [pController release];
    [navController release];
    
}

-(void) setLoading:(BOOL)isLoading {
    self.view.userInteractionEnabled = !isLoading;
    
    if (isLoading) {
        if (self.progressView) {
            [self.progressView removeProgressView];
        }
        self.progressView = [ProgressView progressViewOnView:self.view];
    } else {
        if (self.progressView) {
            [self.progressView removeProgressView];
            self.progressView = nil;
        }
    }
}

// when time is updated, update display
-(void) refreshTime {
    if (self.groups && self.periods) {
        
        NSDate *now = [NSDate date];
        NSString * nowString = [[now description] substringToIndex:10];
        NSString * lastUpdatedString = [[lastUpdated description] substringToIndex:10];
        
        if (![lastUpdatedString isEqualToString:nowString]) {
            [self refreshLocation];

        } else {
            [self refreshReminderDidUpdatedWithGroups:self.groups 
                                              periods:self.periods];
        }
        
    }
}

// update reminder time based on next currently input prefecture, city and street
-(void) refreshLocation {
    [self setLoading:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        self.groups = [self.blackoutService groupsWithPrefecture:self.selectedPrefecture
                                                            city:self.selectedCity
                                                          street:self.selectedStreet];
        
        self.periods = [self.blackoutService periodsWithGroups:self.groups 
                                                      withDate:[NSDate date]];

        self.lastUpdated = [NSDate date];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            [self refreshReminderDidUpdatedWithGroups:self.groups periods:self.periods];
        });
    });
}

-(void) refreshReminderDidUpdatedWithGroups:(NSArray*)blackoutGroups periods:(NSArray*)blackoutPeriods {
    if (!blackoutPeriods || [blackoutPeriods count] == 0) {
        // TODO show alert dialog for error finding period, ask user to select another prefecture
        
        lblTimeTitle.text = @"";
        lblTimeRemaining.text = @"";
        lblTimeDetail.text = @"";
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
            
            if (hourEndBlackout == 0) {
                lblTimeRemaining.text = [NSString stringWithFormat:@"%d分", minuteEndBlackOut];
            } else {
                lblTimeRemaining.text = [NSString stringWithFormat:@"%d時間%d分", hourEndBlackout, minuteEndBlackOut];
            }
            
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
                
                if (hourToBlackout == 0) {
                    lblTimeRemaining.text = [NSString stringWithFormat:@"%d分", minuteToBlackOut];
                } else {
                    lblTimeRemaining.text = [NSString stringWithFormat:@"%d時間%d分", hourToBlackout, minuteToBlackOut];
                }
            } else {
                
                int currentTotalMinute2 = (24 * 60) - [currentComponent minute] - ([currentComponent hour] *60);
                int blackoutFromMinute2 = ([period.fromTime hour] * 60) + [period.fromTime minute];
                
                int remainMinuteToBlackout2 = currentTotalMinute2 + blackoutFromMinute2;
                
                int hourToBlackout = remainMinuteToBlackout2 / 60;
                int minuteToBlackOut = remainMinuteToBlackout2 % 60;
                
                if (hourToBlackout == 0) {
                    lblTimeRemaining.text = [NSString stringWithFormat:@"%d分", minuteToBlackOut];
                } else {
                    lblTimeRemaining.text = [NSString stringWithFormat:@"%d時間%d分", hourToBlackout, minuteToBlackOut];
                }
                
            }
            
        }
    }
    
    // TODO
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, HH:mm"];
    NSString *lastUpdatedString = [dateFormatter stringFromDate:[NSDate date]];
    self.timeTitleView.remainingTime.text = [NSString stringWithFormat:@"更新時間：%@", lastUpdatedString];

}

#pragma mark LocationTableViewControllerDelegate

-(void) locationDidSelectedWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {    
    self.selectedPrefecture = prefecture;
    self.selectedCity = city;
    self.selectedStreet = street;
    
    if (prefecture) {
        [self.btnPrefecture setTitle:prefecture forState:UIControlStateNormal];
    } else {
        // show message when location not found
        [self.btnPrefecture setTitle:@"都県" forState:UIControlStateNormal];
    }
    
    if (city) {
        [self.btnCity setTitle:city forState:UIControlStateNormal];
    } else {
        [self.btnCity setTitle:@"市区郡" forState:UIControlStateNormal];
    }
    
    if (street) {
        [self.btnStreet setTitle:street forState:UIControlStateNormal];
    } else {
        [self.btnStreet setTitle:@"大字通称" forState:UIControlStateNormal];
    }
    
    if (prefecture && city && street) {
        [self refreshLocation];
    }

    [self dismissModalViewControllerAnimated:YES];
}

-(void) locationDidCancelled {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == kAlertViewOne) {
        if (buttonIndex == 1) {
            
            NSLog(@"Open url in Safari");
            NSString* launchUrl = @"http://www.tepco.co.jp";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
        }
        
    } else if (actionSheet.tag == kAlertViewTwo) {
        
        if (buttonIndex == [actionSheet cancelButtonIndex]) {
            
            [self promptInputWithSelectedPrefecture:nil city:nil street:nil];
            _alertOn = NO;
        }
    }
    
}

@end
