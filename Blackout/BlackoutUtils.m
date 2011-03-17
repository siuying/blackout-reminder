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

        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *current = [gregorian components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:currentTime];
        //Calculate the total number of minutes of current time in the day.
        int currentHour = [current hour];
        int currentMin = [current minute];
        int currentTotalMin = (currentHour * 60)+ currentMin;
        
        int nextPeriod = 0;
        
        for (int i=0; i <numberOfPeriods; i++) {
            
            BlackoutPeriod *period = [periods objectAtIndex:i];
            int fromTimeHour = [period.fromTime hour];
            int fromTimeMin = [period.fromTime minute];
            int fromTimeTotalMin = (fromTimeHour * 60) + fromTimeMin;
            
            //As long as end time of the period in the array is yet to come, it is not the next blackout, so nextPeriod +1
            if (currentTotalMin > fromTimeTotalMin && ![self isBlackout:currentTime period:period]) {
                nextPeriod += 1;
                
                if (nextPeriod == [periods count]) {
                    nextPeriod = 0;
                }
            }
        }
        
        return [periods objectAtIndex:nextPeriod];
        
    } else {
        
        return nil;
    }
}

+(BOOL) isBlackout:(NSDate*)currentTime
            period:(BlackoutPeriod*)period {
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *current = [gregorian components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:currentTime];
    
    //Calculate the total number of minutes of current time in the day.
    int currentHour = [current hour];
    int currentMin = [current minute];
    int currentTotalMin = (currentHour * 60)+ currentMin;
    
    //Calculate the total number of minutes of fromTime of the period in the day.
    int fromTimeHour = [period.fromTime hour];
    int fromTimeMin = [period.fromTime minute];
    int fromTimeTotalMin = (fromTimeHour * 60) + fromTimeMin;

    //Calculate the total number of minutes of toTime of the period in the day.
    int toTimeHour = [period.toTime hour];
    int toTimeMin = [period.toTime minute];
    int toTimeTotalMin = (toTimeHour * 60) + toTimeMin;
    
    //Return YES if currentTime is within the blackout period. Otherwise return NO
    if (currentTotalMin > fromTimeTotalMin && currentTotalMin < toTimeTotalMin) {
        
        return YES;
        
    } else {
    
        return NO;
    }
    
    [gregorian release];
}
@end
