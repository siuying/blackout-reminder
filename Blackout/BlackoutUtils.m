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
                                        period:(NSArray*)periods {
    return [NSDate dateWithTimeIntervalSinceNow:3600];
}

+(BOOL) isBlackout:(NSDate*)currentTime
          blackout:(BlackoutPeriod*)period {
    return NO;
}
@end
