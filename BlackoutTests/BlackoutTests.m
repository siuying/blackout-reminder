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


- (void)testNextBlackout
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
    
    // 11:30
    NSDateComponents *time5 = [[[NSDateComponents alloc] init] autorelease];
    [time5 setDay:20];
    [time5 setMonth:4];
    [time5 setYear:2011];
    [time5 setHour:11];
    [time5 setMinute:30];
    
    // 16:00
    NSDateComponents *time3 = [[[NSDateComponents alloc] init] autorelease];
    [time3 setDay:20];
    [time3 setMonth:4];
    [time3 setYear:2011];
    [time3 setHour:16];
    [time3 setMinute:0];
    
    // 13:30
    NSDateComponents *time4 = [[[NSDateComponents alloc] init] autorelease];
    [time4 setDay:20];
    [time4 setMonth:4];
    [time4 setYear:2011];
    [time4 setHour:13];
    [time4 setMinute:30];
    
    // Blackout Period: 9:00 ~ 11:20
    BlackoutPeriod* period1 = [[[BlackoutPeriod alloc] init] autorelease];
    NSDateComponents* from = [[[NSDateComponents alloc] init] autorelease];
    [from setHour:9];
    [from setMinute:0];
    NSDateComponents* to = [[[NSDateComponents alloc] init] autorelease];
    [to setHour:11];
    [to setMinute:20];
    period1.fromTime = from;
    period1.toTime = to;

    // Blackout Period: 13:00 ~ 14:20    
    BlackoutPeriod* period2 = [[[BlackoutPeriod alloc] init] autorelease];
    NSDateComponents* from2 = [[[NSDateComponents alloc] init] autorelease];
    [from2 setHour:13];
    [from2 setMinute:0];
    NSDateComponents* to2 = [[[NSDateComponents alloc] init] autorelease];
    [to2 setHour:14];
    [to2 setMinute:20];
    period2.fromTime = from2;
    period2.toTime = to2;
    
    NSArray* periods = [NSArray arrayWithObjects:period1, period2, nil];
    [BlackoutUtils nextBlackoutWithCurrentTime:[gregorian dateFromComponents:time1]
                                       periods:periods];

    STAssertEqualObjects(period1, [BlackoutUtils nextBlackoutWithCurrentTime:[gregorian dateFromComponents:time2]
                                                                     periods:periods], @"at 06:00, next blackout should be 09:00~11:20");
    STAssertEqualObjects(period1, [BlackoutUtils nextBlackoutWithCurrentTime:[gregorian dateFromComponents:time1]
                                                                     periods:periods], @"at 09:50, next blackout should be 09:00~11:20");
    STAssertEqualObjects(period2, [BlackoutUtils nextBlackoutWithCurrentTime:[gregorian dateFromComponents:time5]
                                                                     periods:periods], @"at 11:30, next blackout should be 13:00~14:20");
    STAssertEqualObjects(period2, [BlackoutUtils nextBlackoutWithCurrentTime:[gregorian dateFromComponents:time4]
                                                                     periods:periods], @"at 13:30, next blackout should be 13:00~14:20");
    STAssertEqualObjects(period1, [BlackoutUtils nextBlackoutWithCurrentTime:[gregorian dateFromComponents:time3]
                                                                     periods:periods], @"at 16:00, next blackout should be 09:00~11:20");
    
    
}

@end
