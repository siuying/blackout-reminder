//
//  BlackoutUtils.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutUtils.h"


@implementation BlackoutUtils

+(BlackoutPeriod*) nextBlackoutWithCurrentTime:(NSDate*)currentTime
                                       periods:(NSArray*)periods {
    if ([periods count] > 0) {
        // TODO really find out the next blackout
        return [periods objectAtIndex:0];
    } else {
        return nil;
    }
}

+(BOOL) isBlackout:(NSDate*)currentTime
            period:(BlackoutPeriod*)period {
    // TODO find if currently is blackout
    return NO;
}
@end
