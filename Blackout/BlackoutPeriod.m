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

-(id) initWithGroup:(BlackoutGroup*)aGroup fromTime:(NSDate*)aFromTime toTime:(NSDate*)aToTime {
    self = [super init];

    self.group = aGroup;    
    self.fromTime = aFromTime;
    self.toTime = aToTime;

    return self;
}

-(void) dealloc {
    self.group = nil;
    self.fromTime = nil;
    self.toTime = nil;
    [super dealloc];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"<Period group=%@, from=%@, to=%@>", 
            self.group, self.fromTime, self.toTime];
}

@end
