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
#import "BlackoutTableViewController.h"

@interface BlackoutViewController (Private)
-(void) refreshReminderDidUpdatedWithGroups:(NSArray*)blackoutGroups periods:(NSArray*)blackoutPeriods;
@end

@implementation BlackoutViewController

@synthesize btnPrefecture, btnCity, btnStreet, btnTime;
@synthesize lblTimeTitle, lblTimeRemaining, lblTimeDetail;
@synthesize buttonWarning, buttonHomepage, boNavigationBar;
@synthesize locationService, blackoutService;
@synthesize selectedPrefecture, selectedCity, selectedStreet;
@synthesize timeTitleView, progressView, timer;
@synthesize groups, periods, lastUpdated, internetConnectionStatus, reachability;

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
    self.timer = nil;
    self.reachability = nil;
    
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
    self.locationService = [[[LocationService alloc] initWithBlackoutService:self.blackoutService] autorelease];
    self.locationService.locationDelegate = self;

    self.btnPrefecture.titleLabel.lineBreakMode = UILineBreakModeClip;
    self.btnCity.titleLabel.lineBreakMode = UILineBreakModeClip;
    self.btnStreet.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    //Load persisted Prefecture, City and Street
    self.selectedPrefecture = [BlackoutAppDelegate prefectureName];
	self.selectedCity = [BlackoutAppDelegate cityName];
	self.selectedStreet = nil;
    
    [self.btnPrefecture setTitle:self.selectedPrefecture forState:UIControlStateNormal];
    [self.btnStreet setTitle:self.selectedStreet forState:UIControlStateNormal];
    [self.btnCity setTitle:self.selectedCity forState:UIControlStateNormal];
    
    // setup navigation bar
    self.timeTitleView = [[[RemaingTimeTitleView alloc] init] autorelease];
    UINavigationItem *barItem = [[UINavigationItem alloc] init];
    [self.timeTitleView setLastUpdatedTime:blackoutService.lastUpdated];
    barItem.titleView = self.timeTitleView;
    barItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_location"] 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:self
                                                                  action:@selector(promptGpsInputLocation)] autorelease];
    barItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"週間" 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:self 
                                                                  action:@selector(clickTime:)]autorelease];
    
    [boNavigationBar pushNavigationItem:barItem animated:NO];
    [barItem release];
    
    //Set a method to be called when a notification is sent.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reachabilityChanged:) 
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    //Set Reachability class to notifiy app when the network status changes.
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [self updateNetworkStatus];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //NSTimer to refresh time 
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                  target:self 
                                                selector:@selector(refreshTime) 
                                                userInfo:nil 
                                                 repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - LocationServiceDelegate

-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names {
    [self.locationService stop];
    [self setLoading:NO];

    if (names && [names count] == 3) {       
        NSLog(@" location name found: %@", names);
        [self locationDidSelectedWithPrefecture:[names objectAtIndex:0]
                                           city:[names objectAtIndex:1]
                                         street:[names objectAtIndex:2]];
        
        
    } else if (names && [names count] == 2) {
        NSLog(@" location name found: %@", names);
        [self locationDidSelectedWithPrefecture:[names objectAtIndex:0]
                                           city:[names objectAtIndex:1]
                                         street:nil];
        
        
    } else if (names && [names count] == 1) {
        NSLog(@" location name found: %@", names);
        [self locationDidSelectedWithPrefecture:[names objectAtIndex:0]
                                           city:nil
                                         street:nil];
        
    } else {
        NSLog(@" *** location not found: %@", names);

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置情報" 
                                                        message:@"マニュアルで位置情報を入力してください。" 
                                                       delegate:self 
                                              cancelButtonTitle:@"はい" 
                                              otherButtonTitles:nil];
        alert.tag = kAlertViewNoLocationFound;
        [alert show];
        [alert release];
    }
}

-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error {
    NSLog(@" error finding location name: %@", error);
    [self.locationService stop];
    [self setLoading:NO];

    // cannot find location name, probably cannot help even retry
    [self promptManualInputLocation:NO];
}



-(void) findLocationDidFailedWithError:(NSError*)error {
    NSLog(@" error finding location: %@", error);
    [self.locationService stop];
    [self setLoading:NO];
    
    // cannot find location, maybe helpful if retry
    [self promptManualInputLocation:YES];
}

#pragma mark - User Actions

-(IBAction) clickPrefecture:(id)sender {
    NSLog(@" clicked prefecture");
    [self manualInputLocationWithPrefecture:nil city:nil street:nil];
}

-(IBAction) clickCity:(id)sender {
    NSLog(@" clicked city: %@", self.selectedPrefecture);
    [self manualInputLocationWithPrefecture:self.selectedPrefecture city:nil street:nil];
}

-(IBAction) clickStreet:(id)sender {
//    NSLog(@" clicked street:%@, %@", self.selectedPrefecture, self.selectedCity);
//    [self manualInputLocationWithPrefecture:self.selectedPrefecture city:self.selectedCity street:nil];
}

-(IBAction) clickTime:(id)sender {
    if (self.periods) {
        BlackoutTableViewController* controller = [[BlackoutTableViewController alloc] initWithBlackoutPeriods:self.periods];
        controller.title = [BlackoutUtils groupsMessage:self.groups];
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentModalViewController:navController animated:YES];
        [controller release];
        [navController release];
    }
}

-(IBAction) openWarning:(id)sender {
    NSLog(@" clicked warning button");
    RemarksViewController *controller = [[RemarksViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navController animated:YES];
    [controller release];
    [navController release];
}

-(IBAction) openTepcoUrl:(id)sender{
    NSLog(@" clicked TEPCO web button");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Safariを起動します" message:@"東京電力のページに移動します。\n宜しいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"はい", nil];
    alert.tag = kAlertViewOpenURL;
    [alert show];
    [alert release];
}

-(IBAction) openIgntSoftUrl:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Safariを起動します" 
                                                    message:@"ページが移動します。\n宜しいですか？"
                                                   delegate:self 
                                          cancelButtonTitle:@"キャンセル" 
                                          otherButtonTitles:@"はい", nil];
    alert.tag = kAlertViewIgntSoftURL;
    [alert show];
    [alert release];
    
}

#pragma mark - Public

-(void) promptGpsInputLocation {
    [self.locationService findLocation];
}

// show alert dialog to warn user about it and ask user manual select
// if retry is YES, ask if user would like to retry
-(void) promptManualInputLocation:(BOOL)retry {
    NSLog(@" *** prompt manual input location");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"位置情報" 
                                                    message:@"位置情報サービスをオンにするか、マニュアルで位置情報を入力してください。" 
                                                   delegate:self 
                                          cancelButtonTitle:@"はい" 
                                          otherButtonTitles:nil];
    alert.tag = kAlertViewNoLocationFound;
    [alert show];
    [alert release];
}

-(void) manualInputLocationWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
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

    [self presentModalViewController:navController animated:YES];
    [pController release];
    [navController release];
    

}

// prompt for user to input location manually
-(void) manualInputLocation {
    NSString* prefecture = self.selectedPrefecture;
    NSString* city = self.selectedCity;
    [self manualInputLocationWithPrefecture:prefecture city:city street:nil];
}

-(void) setLoading:(BOOL)isLoading {
    [self setLoading:isLoading animated:YES];
}

-(void) setLoading:(BOOL)isLoading animated:(BOOL)animated {
    self.view.userInteractionEnabled = !isLoading;
    
    if (isLoading) {
        if (!self.progressView) {
            self.progressView = [ProgressView progressViewOnView:self.view animated:animated];
        }
    } else {
        if (self.progressView) {
            [self.progressView removeProgressView:animated];
            self.progressView = nil;
        }
    }
}

// when time is updated, update display
-(void) refreshTime {
    if (self.groups && self.periods && self.lastUpdated) {
        NSDate *now = [NSDate date];

        NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
        NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;         
        NSDateComponents* nowComponents = [gregorian components:unitFlags fromDate:now];
        NSDateComponents* lastUpdateComponents = [gregorian components:unitFlags fromDate:self.lastUpdated];        

        if ((nowComponents.month != lastUpdateComponents.month || nowComponents.day != lastUpdateComponents.day) || 
            [self shouldRenewServerData]) {

            [self refreshLocation];

        } else {
            [self refreshReminderDidUpdatedWithGroups:self.groups 
                                              periods:self.periods];
        }
        
    }
}

// update reminder time based on next currently input prefecture, city and street
-(void) refreshLocation {
    NSLog(@" refresh location ");
    
    [self setLoading:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.groups = [self.blackoutService groupsWithPrefecture:self.selectedPrefecture
                                                            city:self.selectedCity];
        
        self.periods = [self.blackoutService periodsWithGroups:self.groups];

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
        lblTimeDetail.text = [NSString stringWithFormat:@"停電データは見つかりません。もう一度お試しください。"];
        
    } else {
        
        // more than one period, should find the next period
        NSDate* currentTime = [NSDate date];
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        BlackoutPeriod* period = [BlackoutUtils nextBlackoutWithCurrentTime:currentTime
                                                                    periods:blackoutPeriods];

        BOOL isBlackout = [BlackoutUtils isBlackout:currentTime period:period];
        
        NSDateComponents *periodStartComponent = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) 
                                                             fromDate:period.fromTime];
        NSDateComponents *periodEndComponent = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit) 
                                                           fromDate:period.toTime];
        
        if (isBlackout) {            
            NSDateComponents* diff = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit)
                                                 fromDate:currentTime 
                                                   toDate:period.toTime                          
                                                  options:0];

            
            lblTimeTitle.text = [NSString stringWithFormat:@"停電予定終了まで"];
            lblTimeDetail.text = [NSString stringWithFormat:@"計画停電時間：%d/%d %02d:%02d～%02d:%02d\n停電グループ：%@\n予報マーク：%@", 
                                    [periodStartComponent day],[periodStartComponent month], [periodStartComponent hour],[periodStartComponent minute], 
                                    [periodEndComponent hour], [periodEndComponent minute], 
                                    [BlackoutUtils groupsMessage:self.groups], period.message];
            lblTimeRemaining.text = [BlackoutUtils timeWithDateComponents:diff];
            
        } else {
            NSDateComponents* diff = [calendar components:(NSHourCalendarUnit|NSMinuteCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit)
                                                 fromDate:currentTime 
                                                   toDate:period.fromTime                          
                                                  options:0];
            
            lblTimeTitle.text = [NSString stringWithFormat:@"計画停電まで"];
            lblTimeDetail.text = [NSString stringWithFormat:@"次の計画停電時間：%d/%d %02d:%02d～%02d:%02d\n停電グループ：%@\n予報マーク：%@", 
                                  [periodStartComponent day],[periodStartComponent month], [periodStartComponent hour],[periodStartComponent minute], 
                                  [periodEndComponent hour], [periodEndComponent minute], 
                                  [BlackoutUtils groupsMessage:self.groups], period.message];
            lblTimeRemaining.text = [BlackoutUtils timeWithDateComponents:diff];
        }
    }

    [self.timeTitleView setLastUpdatedTime:self.lastUpdated];
}

-(BOOL)shouldRenewServerData {
    if (!self.lastUpdated) {
        return NO;
    } else {
        NSDate* expiryTime = [self.lastUpdated dateByAddingTimeInterval:FETCH_DATA_EXPIRY];
        NSDate* now = [NSDate date];
        NSDate* laterDate = [now laterDate:expiryTime];
        return laterDate == now;
    }
}

#pragma mark LocationTableViewControllerDelegate

-(void) locationDidSelectedWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    NSLog(@"location did selected with prefecture");
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
        [self.btnStreet setTitle:@"" forState:UIControlStateNormal];
    }
    
    [self dismissModalViewControllerAnimated:YES];
    
    if (prefecture && city) {
        NSLog(@" refresh location");
        [self refreshLocation];
    } else {
        NSLog(@" prompt manual input");
        [self promptManualInputLocation:NO];
    }
}

-(void) locationDidCancelled {
    [self dismissModalViewControllerAnimated:YES];
    
    if (!self.selectedCity) {
        [self promptManualInputLocation:NO];
    }
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == kAlertViewOpenURL) {
        if (buttonIndex == 1) {
            NSLog(@"Open url in Safari");
            NSString* launchUrl = @"http://www.tepco.co.jp";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
        }
        
    } else if (actionSheet.tag == kAlertViewNoLocationFound) {
        
        if (buttonIndex == [actionSheet cancelButtonIndex]) {            
            [self manualInputLocation];
        }

    } else if (actionSheet.tag == kAlertViewIgntSoftURL) {
        if (buttonIndex == 1) {
            
            NSLog(@"Open Ignition Soft url in Safari");
            NSString* launchUrl = @"http://ignition.hk";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
        }
    }
    
}

#pragma mark - Reachabiliy

- (void)reachabilityChanged:(NSNotification *)note {
    [self updateNetworkStatus];
}

- (void)updateNetworkStatus {
    self.internetConnectionStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (self.internetConnectionStatus == NotReachable) {
        NSLog(@"network unreachable");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ネットワーク接続はありません" 
                                                        message:@"本アプリのご使用にネットワーク接続が必要です。インタネットに接続してもう一回お試しください。" 
                                                       delegate:self 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"はい", nil];
        alert.tag = kAlertViewNetworkError;
        [alert show];
        [alert release];

        self.btnPrefecture.enabled = NO;
        self.btnCity.enabled = NO;
        self.btnStreet.enabled = NO;

    }  else {
        NSLog(@"find or restore location");
        self.btnPrefecture.enabled = YES;
        self.btnCity.enabled = YES;
        self.btnStreet.enabled = YES;

        if (USE_MOCK_LOCATION) {
            [self setLoading:YES animated:NO];
            [self.locationService findLocationName:MOCK_LOCATION];
            
        } else {
            if (self.groups && self.periods && ![self shouldRenewServerData]) {
                // groups and periods ready
                [self refreshTime];

            } else if (!self.selectedPrefecture || !self.selectedCity) {
                if ([CLLocationManager locationServicesEnabled]) {
                    [self setLoading:YES animated:NO];
                    [self promptGpsInputLocation];
                    
                } else {
                    NSLog(@"location service is NOT enable");
                    [self promptManualInputLocation:NO];
                    
                }
            } else {
                [self setLoading:YES animated:NO];
                [self refreshLocation];
            }
        }
    }
}


@end
