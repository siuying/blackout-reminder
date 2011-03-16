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

#import "BlackoutService.h"
#import "DummyBlackoutService.h"

@interface BlackoutViewController : UIViewController <LocationServiceDelegate> {   
    // UI
    LocationService* locationService;
    id<BlackoutService> blackoutService;

    IBOutlet UIButton* btnPrefecture;
    IBOutlet UIButton* btnCity;
    IBOutlet UIButton* btnStreet;
    
    IBOutlet UILabel* lblTimeTitle;
    IBOutlet UILabel* lblTimeRemaining;
    IBOutlet UILabel* lblTimeDetail;

    IBOutlet UIButton* buttonWarning;
    IBOutlet UIButton* buttonHomepage;

    IBOutlet UINavigationBar* navigationBar;
    
    // Model
    NSString* selectedPrefecture;
    NSString* selectedCity;
    NSString* selectedStreet;
}


@property (nonatomic, retain) LocationService* locationService;
@property (nonatomic, retain) id<BlackoutService> blackoutService;

@property (nonatomic, retain) IBOutlet UIButton* btnPrefecture;
@property (nonatomic, retain) IBOutlet UIButton* btnCity;
@property (nonatomic, retain) IBOutlet UIButton* btnStreet;

@property (nonatomic, retain) IBOutlet UILabel* lblTimeTitle;
@property (nonatomic, retain) IBOutlet UILabel* lblTimeRemaining;
@property (nonatomic, retain) IBOutlet UILabel* lblTimeDetail;

@property (nonatomic, retain) IBOutlet UIButton* buttonWarning;
@property (nonatomic, retain) IBOutlet UIButton* buttonHomepage;
@property (nonatomic, retain) IBOutlet UINavigationBar* navigationBar;

@property (nonatomic, retain) NSString* selectedPrefecture;
@property (nonatomic, retain) NSString* selectedCity;
@property (nonatomic, retain) NSString* selectedStreet;

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

-(IBAction) openWarning:(id)sender;
-(IBAction) openTepcoUrl:(id)sender;

@end

