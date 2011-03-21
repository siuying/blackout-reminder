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
    
    if (aFromTimeString) {
        NSString* fhour = [aFromTimeString substringWithRange:NSMakeRange(0, 2)];
        NSString* fmin = [aFromTimeString substringWithRange:NSMakeRange(2, 2)];        
        NSDateComponents* fromTimeComponent = [[NSDateComponents alloc] init];
        [fromTimeComponent setHour:[fhour intValue]];
        [fromTimeComponent setMinute:[fmin intValue]];
        self.fromTime = fromTimeComponent;
        [fromTimeComponent release];
    }
    
    if (aToTimeString) {
        NSString* thour = [aToTimeString substringWithRange:NSMakeRange(0, 2)];
        NSString* tmin = [aToTimeString substringWithRange:NSMakeRange(2, 2)];
        NSDateComponents* toTimeComponent = [[NSDateComponents alloc] init];
        [toTimeComponent setHour:[thour intValue]];
        [toTimeComponent setMinute:[tmin intValue]];
         self.toTime = toTimeComponent;        
        [toTimeComponent release];
    }    
    return self;
}

-(void) dealloc {
    self.group = nil;
    self.fromTime = nil;
    self.toTime = nil;
    [super dealloc];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<Period group=%@, from=%02d:%02d, to=%02d:%02d>", 
            self.group, self.fromTime.hour, self.fromTime.minute, self.toTime.hour, self.toTime.minute];
}

@end
