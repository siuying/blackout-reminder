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

+(NSString*) groupsMessage:(NSArray*)groups {
    NSMutableString* message = [NSMutableString string];

    BOOL firstGroup = YES;
    for (BlackoutGroup* group in groups) {
        if (firstGroup) {
            if ([group.company isEqualToString:@"tepco"]) {
                [message appendFormat:@"東京電力"];                
            } else if ([group.company isEqualToString:@"tohoku"]) {
                [message appendFormat:@"東北電力"];                
            }
            firstGroup = NO;
        }
        [message appendFormat:@"第%@グループ ", group.code];
    }
    return [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+(NSString*) timeWithHours:(NSUInteger)hour minutes:(NSUInteger)min {
    NSMutableString* message = [NSMutableString string];
    if (hour != 0) {
        [message appendFormat:@"%d時間", hour];
    }
    
    if (min != 0) {
        [message appendFormat:@"%d分", min];
    }
    return message;
}


@end
