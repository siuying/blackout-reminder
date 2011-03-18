//
//  RemoteBlackoutTests.m
//  Blackout
//
//  Created by Chong Francis on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "RemoteBlackoutTests.h"


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

@end
