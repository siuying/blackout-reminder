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

@end
