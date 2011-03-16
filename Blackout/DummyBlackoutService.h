//
//  DummyBlackoutService.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlackoutService.h"

@interface DummyBlackoutService : NSObject <BlackoutService> {
}

// when this blackout service being updated
-(NSDate*) lastUpdated;

// Find list of prefectures
-(NSArray*) prefectures;

// Find list of cities by prefecture
-(NSArray*) cities:(NSString*)prefecture;

// Find list of street by prefecture and city
-(NSArray*) streetsWithPrefecture:(NSString*)prefecture city:(NSString*)city;

// Array of BlackoutPeriod that match the street
-(NSArray*) periodWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street;


@end
