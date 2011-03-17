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
    
    currentTime = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    //Convert NSDateComponent to NSDate for comparison
    NSDate *blackoutStart = [gregorian dateFromComponents:period.fromTime];
    NSDate *blackoutEnd = [gregorian dateFromComponents:period.toTime];
    
    //To compare whether currentTime is within the blackout period.
    NSComparisonResult startResult = [currentTime compare:blackoutStart];
    NSComparisonResult endResult = [currentTime compare:blackoutEnd];
    
    if (startResult == NSOrderedDescending && endResult == NSOrderedAscending) {
        
        return YES;
        
    } else {
    
        return NO;
    }
}
@end
