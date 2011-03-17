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
        
        NSInteger numberOfPeriods = [periods count];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        int nextPeriod = 0;
        
        for (int i=0; i <numberOfPeriods; i++) {
            
            
            BlackoutPeriod *period = [periods objectAtIndex:i];
            NSDate *blackoutStart = [gregorian dateFromComponents:period.fromTime];
            NSComparisonResult startResult = [currentTime compare:blackoutStart];
            
            //As long as start time of the period in the array is before current time, it is not the next blackout, so nextPeriod +1
            if (startResult == NSOrderedDescending) {
                nextPeriod += 1;
            }
        }
        
        return [periods objectAtIndex:nextPeriod];
        
    } else {
        
        return nil;
    }
}

+(BOOL) isBlackout:(NSDate*)currentTime
            period:(BlackoutPeriod*)period {
    
    currentTime = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    //Convert NSDateComponent to NSDate for comparison
    NSDate *blackoutStart = [gregorian dateFromComponents:period.fromTime];
    NSDate *blackoutEnd = [gregorian dateFromComponents:period.toTime];
    
    //To compare whether currentTime is within the blackout period.
    NSComparisonResult startResult = [currentTime compare:blackoutStart];
    NSComparisonResult endResult = [currentTime compare:blackoutEnd];
    
    //Return YES if currentTime is within the blackout period. Otherwise return NO
    if (startResult == NSOrderedDescending && endResult == NSOrderedAscending) {
        
        return YES;
        
    } else {
    
        return NO;
    }
    
    [gregorian release];
}
@end
