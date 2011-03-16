//
//  BlackoutViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutViewController.h"
#import "BlackoutAppDelegate.h"

@implementation BlackoutViewController

@synthesize lblPrefecture, lblCity, lblStreet;
@synthesize locationService;

- (void)dealloc
{
    self.locationService = nil;
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
    
    self.locationService = [[[LocationService alloc] init] autorelease];
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

    self.lblPrefecture = nil;
    self.lblCity = nil;
    self.lblStreet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - LocationServiceDelegate

-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names {
    if (names && [names count] == 3) {
        NSLog(@" location found: %@", names);
        self.lblPrefecture.text     = [names objectAtIndex:0];
        self.lblCity.text           = [names objectAtIndex:1];
        self.lblStreet.text         = [names objectAtIndex:2];
        
        // query the prefecture, city and street for next hour
    }
}

-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error {
    // report error
    // ask for retry
}

#pragma mark - User Actions

-(IBAction) clickPrefecture:(id)sender {
}

-(IBAction) clickCity:(id)sender {
}

-(IBAction) clickStreet:(id)sender {
}

-(IBAction) openTepcoUrl:(id)sender{
}

#pragma mark - Public

// popup list of prefecture for user select
// when complete, invoke popupCityListWithPrefecture:
-(void) popupPrefectureList{
}

// popup list of city for user select
// when complete, invoke popupStreetListWithPrefecture:street:
-(void) popupCityListWithPrefecture:(NSString*)prefecture{
}

// popup list of street for user select
// when complete, invoke refreshReminder
-(void) popupStreetListWithPrefecture:(NSString*)prefecture street:(NSString*)street{
}

// asynchronously find current location, then set the prefecture, city and street
// if failed, as for retry or manual override
-(void) selectCurrentLocation {
}

// update reminder time based on next currently input prefecture, city and street
-(void) refreshReminder {
}

@end
