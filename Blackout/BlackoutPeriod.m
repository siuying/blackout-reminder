//
//  BlackoutPeriod.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutPeriod.h"

@implementation BlackoutPeriod

@synthesize group, fromTime, toTime;

-(id) initWithGroup:(BlackoutGroup*)aGroup fromTimeString:(NSString*)aFromTimeString toTimeString:(NSString*)aToTimeString {
    self = [super init];

    self.group = aGroup;
    
    if ([aFromTimeString length] == 4) {
        NSString* hour = [aFromTimeString substringWithRange:NSMakeRange(0, 2)];
        NSString* min = [aFromTimeString substringWithRange:NSMakeRange(2, 2)];

        NSDateComponents* fromTimeComponent = [[NSDateComponents alloc] init];
        [fromTimeComponent setHour:[hour intValue]];
        [fromTimeComponent setMinute:[min intValue]];
        [fromTimeComponent release];
        self.fromTime = fromTimeComponent;
    }
    
    if ([aToTimeString length] == 4) {
        NSString* hour = [aToTimeString substringWithRange:NSMakeRange(0, 2)];
        NSString* min = [aToTimeString substringWithRange:NSMakeRange(2, 2)];
        
        NSDateComponents* toTimeComponent = [[NSDateComponents alloc] init];
        [toTimeComponent setHour:[hour intValue]];
        [toTimeComponent setMinute:[min intValue]];
        [toTimeComponent release];        
         self.toTime = toTimeComponent;        
    }    
    return self;
}

-(void) dealloc {
    self.group = nil;
    self.fromTime = nil;
    self.toTime = nil;
    [super dealloc];
}
@end
