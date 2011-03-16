//
//  BlackoutViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationService.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BlackoutViewController : UIViewController <LocationServiceDelegate> {
    LocationService* locationService;

    IBOutlet UILabel* lblPrefecture;
    IBOutlet UILabel* lblCity;
    IBOutlet UILabel* lblStreet;
}


@property (nonatomic, retain) LocationService* locationService;

@property (nonatomic, retain) IBOutlet UILabel* lblPrefecture;
@property (nonatomic, retain) IBOutlet UILabel* lblCity;
@property (nonatomic, retain) IBOutlet UILabel* lblStreet;

// popup list of prefecture for user select
// when complete, invoke popupCityListWithPrefecture:
-(void) popupPrefectureList;

// popup list of city for user select
// when complete, invoke popupStreetListWithPrefecture:street:
-(void) popupCityListWithPrefecture:(NSString*)prefecture;

// popup list of street for user select
// when complete, invoke refreshReminder
-(void) popupStreetListWithPrefecture:(NSString*)prefecture street:(NSString*)street;

// asynchronously find current location, then set the prefecture, city and street
// if failed, as for retry or manual override
-(void) selectCurrentLocation;

// update reminder time based on next currently input prefecture, city and street
-(void) refreshReminder;

@end

@interface BlackoutViewController (UIActions)

-(IBAction) clickPrefecture:(id)sender;
-(IBAction) clickCity:(id)sender;
-(IBAction) clickStreet:(id)sender;

-(IBAction) openTepcoUrl:(id)sender;

@end

