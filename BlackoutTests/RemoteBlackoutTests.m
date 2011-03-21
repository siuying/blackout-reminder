//
//  RemoteBlackoutTests.m
//  Blackout
//
//  Created by Chong Francis on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "RemoteBlackoutTests.h"

@interface RemoteBlackoutService (Private)
-(NSArray*) groupsWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street;
@end

@implementation RemoteBlackoutTests

- (void)testPrefecture {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];
    
    NSArray* prefectures = [service prefectures];
    STAssertNotNil(prefectures, @"should not be nil");
    STAssertTrue(9 == [prefectures count], @"should have 9 prefectures, currently %d", [prefectures count]);
    NSLog(@"prefectures: %@", prefectures);

    [service release];
}

- (void)testCity {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];
    
    NSArray* cities = [service cities:@"千葉県"];
    NSLog(@"cities: %@", cities);
    STAssertNotNil(cities, @"should not be nil");
    STAssertTrue(0 < [cities count], @"should have at least 1 cities, currently %d", [cities count]);
    
    cities = [service cities:@"栃木県"];
    NSLog(@"cities: %@", cities);
    STAssertNotNil(cities, @"should not be nil");
    STAssertTrue(0 < [cities count], @"should have at least 1 cities, currently %d", [cities count]);
    
    cities = [service cities:@"木木県"];
    NSLog(@"cities: %@", cities);
    STAssertNotNil(cities, @"should not be nil");
    STAssertTrue(0 == [cities count], @"should return 0 cities, currently %d", [cities count]);
    
    [service release];
}

- (void)testStreet {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];

    NSArray* streets = [service streetsWithPrefecture:@"栃木県" city:@"下都賀郡壬生町"];
    NSLog(@"streets: %@", streets);
    STAssertNotNil(streets, @"should not be nil");
    STAssertTrue(48 == [streets count], @"should have 48 streets, currently %d", [streets count]);
    [service release];
}

- (void)testGroup {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];
    
    NSArray* groups = [service groupsWithPrefecture:@"千葉県" city:@"いすみ市" street:@"岬町中原"];
    NSLog(@"groups: %@", groups);
    STAssertNotNil(groups, @"should not be nil");
    STAssertTrue(1 == [groups count], @"should have 1 group, currently %d", [groups count]);
    STAssertTrue([groups containsObject:@"1"], @"should contain 1");
    
    groups = [service groupsWithPrefecture:@"静岡県" city:@"駿東郡  清水町" street:@"畑中"];
    NSLog(@"groups: %@", groups);
    STAssertNotNil(groups, @"should not be nil");
    STAssertTrue(2 == [groups count], @"should have 1 group, currently %d", [groups count]);
    STAssertTrue([groups containsObject:@"2"], @"should contain 2");
    STAssertTrue([groups containsObject:@"3"], @"should contain 3");
    
    
    
    [service release];
}

- (void)testPeriod {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];
    
    NSDateComponents* component = [[NSDateComponents alloc] init];
    [component setYear:2011];
    [component setMonth:3];
    [component setDay:22];
    [component setHour:0];
    [component setMinute:0];
    [component setSecond:0];
    
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDate* date = [gregorian dateFromComponents:component];
    
    BlackoutGroup* group = [[BlackoutGroup alloc] initWithCompany:@"tepco" code:@"1"];
    NSArray* periods = [service periodsWithGroups:[NSArray arrayWithObject:group] withDate:date];
    STAssertTrue([periods count] == 2, @"should return a period, now: %@", periods);
    
    if ([periods count] >= 2) {
        BlackoutPeriod* period1 = [periods objectAtIndex:0];
        STAssertNotNil(period1, @"should return a period");    
        STAssertTrue(period1.fromTime.hour == 9, @"should start 09:20, period=%@", period1);   
        STAssertTrue(period1.fromTime.minute == 20, @"should start 09:20, period=%@", period1);   
        STAssertTrue(period1.toTime.hour == 13, @"should end 13:00, period=%@", period1);   
        STAssertTrue(period1.toTime.minute == 0, @"should end 13:00, period=%@", period1);   
        
        BlackoutPeriod* period2 = [periods objectAtIndex:1];
        STAssertNotNil(period2, @"should return a period");    
        STAssertTrue(period2.fromTime.hour == 16, @"should start 16:50, period=%@", period2);   
        STAssertTrue(period2.fromTime.minute == 50, @"should start 16:50, period=%@", period2);   
        STAssertTrue(period2.toTime.hour == 19, @"should end 19:00, period=%@", period2);   
        STAssertTrue(period2.toTime.minute == 0, @"should end 19:00, period=%@", period2);   
    }
    
    [service release];
}

@end
