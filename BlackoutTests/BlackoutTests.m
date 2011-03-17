//
//  BlackoutTests.m
//  BlackoutTests
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutTests.h"
#import "BlackoutUtils.h"

@implementation BlackoutTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testIsBlackout
{
    
    NSCalendar *gregorian = [[NSCalendar alloc]                             
                             initWithCalendarIdentifier:NSGregorianCalendar];

    // 9:50
    NSDateComponents *time1 = [[[NSDateComponents alloc] init] autorelease];
    [time1 setDay:20];
    [time1 setMonth:4];
    [time1 setYear:2011];
    [time1 setHour:9];
    [time1 setMinute:50];

    // 6:00
    NSDateComponents *time2 = [[[NSDateComponents alloc] init] autorelease];
    [time2 setDay:20];
    [time2 setMonth:4];
    [time2 setYear:2011];
    [time2 setHour:6];
    [time2 setMinute:0];

    // 12:00
    NSDateComponents *time3 = [[[NSDateComponents alloc] init] autorelease];
    [time3 setDay:20];
    [time3 setMonth:4];
    [time3 setYear:2011];
    [time3 setHour:12];
    [time3 setMinute:0];
    
    // Blackout Period: 9:00 ~ 11:20
    BlackoutPeriod* period = [[[BlackoutPeriod alloc] init] autorelease];
    NSDateComponents* from = [[[NSDateComponents alloc] init] autorelease];
    [from setHour:9];
    [from setMinute:0];
    NSDateComponents* to = [[[NSDateComponents alloc] init] autorelease];
    [to setHour:11];
    [to setMinute:20];
    period.fromTime = from;
    period.toTime = to;
    
    STAssertTrue([BlackoutUtils isBlackout:[gregorian dateFromComponents:time1] period:period], @"9:50 should be in blackout");
    STAssertTrue([BlackoutUtils isBlackout:[gregorian dateFromComponents:time2] period:period], @"6:00 should NOT be in blackout");
    STAssertTrue([BlackoutUtils isBlackout:[gregorian dateFromComponents:time3] period:period], @"12:00 should NOT be in blackout");
}

@end
