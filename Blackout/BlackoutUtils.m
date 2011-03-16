//
//  BlackoutUtils.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutUtils.h"


@implementation BlackoutUtils

+(NSDate*) nextBlackoutWithCurrentTime:(NSDate*)currentTime
                                period:(NSArray*)periods {
    return [NSDate dateWithTimeIntervalSinceNow:3600];
}

@end
