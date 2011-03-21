//
//  BlackoutUtils.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//
// Reference: http://developer.apple.com/library/mac/#documentation/cocoa/Conceptual/DatesAndTimes/Articles/dtCalendars.html

#import <Foundation/Foundation.h>
#import "BlackoutPeriod.h"

@interface BlackoutUtils : NSObject {
}

// if currently inside blackout time, return the blackout period
// if currently NOT inside blackout time, find next blackout
+(BlackoutPeriod*) nextBlackoutWithCurrentTime:(NSDate*)currentTime
                                       periods:(NSArray*)periods;

+(BOOL) isBlackout:(NSDate*)currentTime
            period:(BlackoutPeriod*)period;

// provided array of BlackoutGroup, return string to describe the groups
+(NSString*) groupsMessage:(NSArray*)groups;

+(NSString*) timeWithHours:(NSUInteger)hour minutes:(NSUInteger)min;

@end
