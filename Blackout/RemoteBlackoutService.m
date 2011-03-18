//
//  RemoteBlackoutService.m
//  Blackout
//
//  Created by Chong Francis on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "RemoteBlackoutService.h"
#import "ASIHTTPRequest.h"

#define kBlackoutUrlBase    @"https://ignition.cloudant.com"
#define kBlackoutDb         @"blackout-dev"
#define kBlackoutUsername   @"behictingualdrionschaver"
#define kBlackoutPassword   @"lqNLPtLRyNDcW1nk4cT81SvP"

#define kBlackoutMethodPrefectures     @"_design/api/_view/prefectures"

@implementation RemoteBlackoutService

@synthesize lastUpdated;

// Find list of prefectures
// dummy method always return preset values
-(NSArray*) prefectures {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kBlackoutUrlBase, kBlackoutDb, kBlackoutMethodPrefectures]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setSecondsToCache:60*60];
    [request startSynchronous];

    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
    }
    
    
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

// Array of BlackoutPeriod that match the street
// dummy method always return preset values
-(NSArray*) periodWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    if (!prefecture || !city || !street) {
        return [NSArray array];
    }
    
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
@end
