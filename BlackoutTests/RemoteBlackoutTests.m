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
    STAssertNotNil(groups, @"should not be nil");
    STAssertTrue(1 == [groups count], @"should have 1 group, currently %d", [groups count]);
    if ([groups count] ==1){
        BlackoutGroup* group = [groups objectAtIndex:0];
        STAssertTrue([group.company isEqual:@"tepco"], @"should contain 1");
        STAssertTrue([group.code isEqual:@"1"], @"should contain 1");
    }
    
    groups = [service groupsWithPrefecture:@"静岡県" city:@"駿東郡  清水町" street:@"畑中"];
    NSLog(@"groups: %@", groups);
    
    STAssertTrue(2 == [groups count], @"should have 1 group, currently %d", [groups count]);
    if ([groups count] == 2) {    
        BlackoutGroup* group1 = [groups objectAtIndex:0];
        BlackoutGroup* group2 = [groups objectAtIndex:1];
        STAssertTrue([group1.code isEqual:@"2"], @"should contain 2");
        STAssertTrue([group2.code isEqual:@"3"], @"should contain 3");
    }    
    
    
    [service release];
}

- (void)testPeriod {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];
    
    NSDateComponents* component = [[[NSDateComponents alloc] init] autorelease];
    [component setYear:2011];
    [component setMonth:3];
    [component setDay:22];
    [component setHour:0];
    [component setMinute:0];
    [component setSecond:0];
    
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];

    BlackoutGroup* group = [[BlackoutGroup alloc] initWithCompany:@"tepco" code:@"1"];
    NSArray* periods = [service periodsWithGroups:[NSArray arrayWithObject:group]];
    STAssertTrue([periods count] > 2, @"should return a period, now: %@", periods);
    
    if ([periods count] >= 2) {
        BlackoutPeriod* period1 = [periods objectAtIndex:0];
        STAssertNotNil(period1, @"should return a period");

        // test case changes daily
//        NSDateComponents* fromComp = [gregorian components: NSMonthCalendarUnit|NSDayCalendarUnit fromDate:period1.fromTime];
//        NSDateComponents* toComp = [gregorian components: NSMonthCalendarUnit|NSDayCalendarUnit fromDate:period1.toTime];
        
//        STAssertTrue(fromComp.hour == 9, @"should start 09:20, period=%@", period1);   
//        STAssertTrue(fromComp.minute == 20, @"should start 09:20, period=%@", period1);   
//        STAssertTrue(toComp.hour == 13, @"should end 13:00, period=%@", period1);   
//        STAssertTrue(toComp.minute == 0, @"should end 13:00, period=%@", period1);   
//        
//        BlackoutPeriod* period2 = [periods objectAtIndex:1];
//        STAssertNotNil(period2, @"should return a period");    
//        NSDateComponents* from2Comp = [gregorian components: NSMonthCalendarUnit|NSDayCalendarUnit fromDate:period2.fromTime];
//        NSDateComponents* to2Comp = [gregorian components: NSMonthCalendarUnit|NSDayCalendarUnit fromDate:period2.toTime];
//        
//        STAssertTrue(from2Comp.hour == 16, @"should start 16:50, period=%@", period2);   
//        STAssertTrue(from2Comp.minute == 50, @"should start 16:50, period=%@", period2);   
//        STAssertTrue(to2Comp.hour == 19, @"should end 19:00, period=%@", period2);   
//        STAssertTrue(to2Comp.minute == 0, @"should end 19:00, period=%@", period2);   
    }
    
    [service release];
}

-(void) testValidateLocation {
    RemoteBlackoutService* service = [[RemoteBlackoutService alloc] init];
    
    // 千葉県-いすみ市-万木
    NSArray* result1 = [service validatePrefecture:@"千葉県" city:@"いすみ市" street:@"万木"];
    STAssertTrue([result1 count] == 3, @"should return array with 3 objects");
    STAssertEquals([result1 objectAtIndex:0], @"千葉県", @" should be 千葉県");
    STAssertEquals([result1 objectAtIndex:1], @"いすみ市", @" should be いすみ市");
    STAssertEquals([result1 objectAtIndex:2], @"万木", @" should be 万木");
    
    NSArray* result2 = [service validatePrefecture:@"千葉県" city:@"いすみ市" street:@"木木木木万木"];
    STAssertTrue([result2 count] == 2, @"should return array with 2 objects");
    STAssertEquals([result2 objectAtIndex:0], @"千葉県", @" should be 千葉県");
    STAssertEquals([result2 objectAtIndex:1], @"いすみ市", @" should be いすみ市");
    
    NSArray* result3 = [service validatePrefecture:@"千葉県" city:@"いいいいすみ市" street:@"木木木木万木"];
    STAssertTrue([result3 count] == 1, @"should return array with 1 objects");
    STAssertEquals([result3 objectAtIndex:0], @"千葉県", @" should be 千葉県");
    
    NSArray* result4 = [service validatePrefecture:@"千千千千葉県" city:@"いいいいすみ市" street:@"木木木木万木"];
    STAssertTrue([result4 count] == 0, @"should return array with 0 objects");
    
    // 東京都-あきる野市-三内
    result1 = [service validatePrefecture:@"東京都" city:@"あきる野市" street:@"三内"];
    STAssertTrue([result1 count] == 3, @"should return array with 3 objects");
    STAssertEquals([result1 objectAtIndex:0], @"東京都", @" should be 東京都");
    STAssertEquals([result1 objectAtIndex:1], @"あきる野市", @" should be あきる野市");
    STAssertEquals([result1 objectAtIndex:2], @"三内", @" should be 三内");
    
    result1 = [service validatePrefecture:@"東京都" city:@"あきる野市" street:@"三"];
    STAssertTrue([result1 count] == 2, @"should return array with 2 objects");
    STAssertEquals([result1 objectAtIndex:0], @"東京都", @" should be 東京都");
    STAssertEquals([result1 objectAtIndex:1], @"あきる野市", @" should be あきる野市");
    
    
    
    [service release];
}

@end
