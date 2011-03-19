//
//  DummyBlackoutService.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "DummyBlackoutService.h"

@implementation DummyBlackoutService

// when this blackout service being updated
-(NSDate*) lastUpdated {
    return [NSDate date];
}

// Find list of prefectures
// dummy method always return preset values
-(NSArray*) prefectures {
    return [NSArray arrayWithObjects:@"栃木", @"茨城", @"群馬", @"千葉", @"神奈川", @"東京", @"埼玉", @"山梨", @"静岡", nil];
}

// Find list of cities by prefecture
// dummy method always return preset values
-(NSArray*) cities:(NSString*)prefecture {
    return [NSArray arrayWithObjects:@"国分寺市", @"国立市", @"日野市", @"三鷹市", @"稲城市", @"羽村市", nil];
}

// Find list of street by prefecture and city
// dummy method always return preset values
-(NSArray*) streetsWithPrefecture:(NSString*)prefecture city:(NSString*)city {
    return [NSArray arrayWithObjects:@"緑ケ丘５丁目",
            @"緑ケ丘４丁目",
            @"緑ケ丘３丁目",
            @"緑ケ丘２丁目",
            @"緑ケ丘１丁目",
            @"富士見平３丁目",
            @"富士見平２丁目",
            @"富士見平１丁目",
            @"双葉町３丁目",
            @"双葉町２丁目",
            @"双葉町１丁目",
            @"川崎４丁目",
            @"川崎３丁目",
            @"川崎２丁目",
            @"川崎１丁目",
            @"川崎", 
            nil];
}

// Array of string of groups that match the prefecture, city and street
// If no groups found, return empty array
-(NSArray*) groupsWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    if (!prefecture || !city || !street) {
        return [NSArray array];
    }

    return [NSArray arrayWithObject:@"1"];
}

// Array of BlackoutPeriod from the groups
// If no electricity for the groups found, return empty array
-(NSArray*) periodsWithGroups:(NSArray*)groups {
    BlackoutPeriod* p = [[[BlackoutPeriod alloc] init] autorelease];
    
    NSDateComponents* from = [[[NSDateComponents alloc] init] autorelease];
    [from setHour:10];
    [from setMinute:0];

    NSDateComponents* to = [[[NSDateComponents alloc] init] autorelease];
    [to setHour:12];
    [to setMinute:20];

    p.fromTime = from;
    p.toTime = to;
    
    BlackoutPeriod* p2 = [[[BlackoutPeriod alloc] init] autorelease];
    
    NSDateComponents* from2 = [[[NSDateComponents alloc] init] autorelease];
    [from2 setHour:15];
    [from2 setMinute:0];
    
    NSDateComponents* to2 = [[[NSDateComponents alloc] init] autorelease];
    [to2 setHour:19];
    [to2 setMinute:20];
    
    p2.fromTime = from2;
    p2.toTime = to2;

    return [NSArray arrayWithObjects:p, p2, nil];
}

// Validate if the specific Prefecture, City and Street existed in db, if not, return the cloest match
// Mock method always return input values
-(NSArray*) validatePrefectures:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    return [NSArray arrayWithObjects:prefecture, city, street, nil];
}

@end
