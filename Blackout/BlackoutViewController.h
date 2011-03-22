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

#import "BlackoutUtils.h"
#import "PrefectureTableViewController.h"
#import "CityTableViewController.h"
#import "StreetTableViewController.h"
#import "LocationTableViewController.h"
#import "RemarksViewController.h"

#import "RemaingTimeTitleView.h"
#import "ProgressView.h"

#define kAlertViewOpenURL   1
#define kAlertViewNoLocationFound   2
#define kAlertViewIgntSoftURL 3

@interface BlackoutViewController : UIViewController <LocationServiceDelegate, LocationTableViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
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

    IBOutlet UINavigationBar* boNavigationBar;
    RemaingTimeTitleView* timeTitleView;
    ProgressView* progressView;
    NSTimer* timer;
    
    BOOL _alertOn;
    
    // Model
    NSString* selectedPrefecture;
    NSString* selectedCity;
    NSString* selectedStreet;

    NSArray* groups;
    NSArray* periods;
    NSDate* lastUpdated;
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
@property (nonatomic, retain) IBOutlet UINavigationBar* boNavigationBar;
@property (nonatomic, retain) RemaingTimeTitleView* timeTitleView;
@property (nonatomic, retain) ProgressView* progressView;
@property (nonatomic, retain) NSTimer* timer;

@property (nonatomic) BOOL alertOn; 

@property (nonatomic, retain) NSString* selectedPrefecture;
@property (nonatomic, retain) NSString* selectedCity;
@property (nonatomic, retain) NSString* selectedStreet;

@property (nonatomic, retain) NSArray* groups;
@property (nonatomic, retain) NSArray* periods;
@property (nonatomic, retain) NSDate* lastUpdated;

// If isLoading = YES, disable UI and show a loading screen
// Otherwise, remove the loading screen
-(void) setLoading:(BOOL)isLoading;

-(void) setLoading:(BOOL)isLoading animated:(BOOL)animated;

// update reminder time based on next currently input prefecture, city and street
-(void) refreshLocation;

-(void) refreshTime;

-(void) promptGpsInputLocation;

-(void) promptManualInputLocation:(BOOL)retry;

-(void) manualInputLocation;

@end

@interface BlackoutViewController (UIActions)

-(IBAction) clickPrefecture:(id)sender;
-(IBAction) clickCity:(id)sender;
-(IBAction) clickStreet:(id)sender;

-(IBAction) openWarning:(id)sender;
-(IBAction) openTepcoUrl:(id)sender;
-(IBAction) openIgntSoftUrl:(id)sender;

@end

