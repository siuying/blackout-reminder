//
//  BlackoutAppDelegate.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PREFECTURE_KEY      @"prefecture_name"
#define CITY_KEY            @"city_name"
#define STREET_KEY          @"street_name"

@class BlackoutViewController;

@interface BlackoutAppDelegate : NSObject <UIApplicationDelegate> {
    
    NSString *prefectureName;
    NSString *cityName;
    NSString *streetName;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BlackoutViewController *viewController;

@property (nonatomic, retain) NSString *prefectureName;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *streetName;

+(void)setPrefectureName:(NSString*)newPrefecture;
+(NSString*)displayPrefecture;
+(void)setCityName:(NSString*)newCity;
+(NSString*)displayCity;
+(void)setStreetName:(NSString*)newStreet;
+(NSString*)displayStreet;

@end
