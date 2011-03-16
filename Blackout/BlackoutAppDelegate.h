//
//  BlackoutAppDelegate.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationService.h"

@class BlackoutViewController;

@interface BlackoutAppDelegate : NSObject <UIApplicationDelegate, LocationServiceDelegate> {
    LocationService* locationService;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BlackoutViewController *viewController;

@property (nonatomic, retain) LocationService* locationService;

@end
