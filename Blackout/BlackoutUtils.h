//
//  BlackoutUtils.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BlackoutPeriod.h"

@interface BlackoutUtils : NSObject {
}

// if currently inside blackout time, return the blackout period
// if currently NOT inside blackout time, find next blackout
+(BlackoutPeriod*) nextBlackoutWithCurrentTime:(NSDate*)currentTime
                                        period:(NSArray*)periods;

+(BOOL) isBlackout:(NSDate*)currentTime
           periods:(BlackoutPeriod*)period;

@end
