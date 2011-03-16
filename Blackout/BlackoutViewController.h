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

// popup prefecture list
// once selected will set the prefecture and select city
-(void) selectPrefecture;

// popup city list for currently selected prefecture
// once selected will set the city and select street
// if prefecture not set, no effect
-(void) selectCity;

// popup street list for currently selected prefecture and city
// once selected will set the street and call find location
// if prefecture or city not set, no effect
-(void) selectStreet;


// find current location, and populate the prefecture, city and street.
// if location cannot be found, show error and ask for retry or manual selection
// if one or more "period" match the "prefecture, city and street", use the period
// if one or more street match the "prefecture and city", show find street
// if one or more street match the "prefecture", show find city
// if no match for prefecture, show error and ask for retry or manual selection
-(void) selectCurrentLocation;

@end

@interface BlackoutViewController (UIActions)

-(IBAction) clickPrefecture:(id)sender;
-(IBAction) clickCity:(id)sender;
-(IBAction) clickStreet:(id)sender;

-(IBAction) openTepcoUrl:(id)sender;

@end

