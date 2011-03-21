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
        for (BlackoutPeriod* period in periods) {
            if ([currentTime compare:period.toTime] == NSOrderedAscending) {
                return period;
            }
        }
        
    }
    
    return nil;

}

+(BOOL) isBlackout:(NSDate*)currentTime
            period:(BlackoutPeriod*)period {
    return [currentTime compare:period.fromTime] == NSOrderedDescending && 
        [currentTime compare:period.toTime] == NSOrderedAscending;
}

@end
