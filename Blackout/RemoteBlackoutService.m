//
//  RemoteBlackoutService.m
//  Blackout
//
//  Created by Chong Francis on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "RemoteBlackoutService.h"

#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"

#define kBlackoutUrlBase    @"https://ignition.cloudant.com"
#define kBlackoutDb         @"blackout-dev"
#define kBlackoutUsername   @"behictingualdrionschaver"
#define kBlackoutPassword   @"lqNLPtLRyNDcW1nk4cT81SvP"

#define kBlackoutMethodPrefectures      @"_design/api/_view/prefectures?group=true"
#define kBlackoutMethodCities           @"_design/api/_view/cities"
#define kBlackoutMethodStreets          @"_design/api/_view/streets"
#define kBlackoutMethodGroup            @"_design/api/_view/blackout"

@implementation RemoteBlackoutService

@synthesize lastUpdated;

// Find list of prefectures
-(NSArray*) prefectures {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kBlackoutUrlBase, kBlackoutDb, kBlackoutMethodPrefectures]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:kBlackoutUsername];
    [request setPassword:kBlackoutPassword];
    [request setSecondsToCache:60*60];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request startSynchronous];

    NSError *error = [request error];
    if (!error) {
        NSData *response = [request responseData];
        NSDictionary* data = [[CJSONDeserializer deserializer] deserializeAsDictionary:response 
                                                                                 error:&error];
        
        if (!error) {
            NSArray* rows = [data objectForKey:@"rows"];
            NSMutableArray* prefectures = [NSMutableArray array];
            for (NSDictionary* entry in rows) {
                [prefectures addObject:[entry objectForKey:@"key"]];
            }
            return [[prefectures copy] autorelease];
        } else {
            NSLog(@"error parsing prefecture: %@", error);            
        }
    } else {
        NSLog(@"error reading prefecture: %@", error);
    }

    return [NSArray array];
}

// Find list of cities by prefecture
-(NSArray*) cities:(NSString*)prefecture {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@?startkey=%@&endkey=%@&group=true", 
                                       kBlackoutUrlBase, 
                                       kBlackoutDb, 
                                       kBlackoutMethodCities, 
                                       [[NSString stringWithFormat:@"[\"%@\"]", prefecture] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                       [[NSString stringWithFormat:@"[\"%@\", {}]", prefecture] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                       ]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:kBlackoutUsername];
    [request setPassword:kBlackoutPassword];
    [request setSecondsToCache:60*60];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response = [request responseData];
        NSDictionary* data = [[CJSONDeserializer deserializer] deserializeAsDictionary:response 
                                                                                 error:&error];
        
        if (!error) {
            NSArray* rows = [data objectForKey:@"rows"];
            NSMutableArray* cities = [NSMutableArray array];
            for (NSDictionary* entry in rows) {
                NSArray* keys = [entry objectForKey:@"key"];
                if (keys && [keys count] == 2) {
                    [cities addObject:[keys objectAtIndex:1]];
                }
            }
            return [[cities copy] autorelease];
        } else {
            NSLog(@"error parsing cities: %@", error);            
        }
    } else {
        NSLog(@"error reading cities: %@", error);
    }

    return [NSArray array];
}

// Find list of street by prefecture and city
-(NSArray*) streetsWithPrefecture:(NSString*)prefecture city:(NSString*)city {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@?startkey=%@&endkey=%@&group=true", 
                                       kBlackoutUrlBase, 
                                       kBlackoutDb, 
                                       kBlackoutMethodStreets, 
                                       [[NSString stringWithFormat:@"[\"%@\",\"%@\"]", prefecture, city] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                       [[NSString stringWithFormat:@"[\"%@\",\"%@\", {}]", prefecture, city] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                       ]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:kBlackoutUsername];
    [request setPassword:kBlackoutPassword];
    [request setSecondsToCache:60*60];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response = [request responseData];
        NSDictionary* data = [[CJSONDeserializer deserializer] deserializeAsDictionary:response 
                                                                                 error:&error];
        
        if (!error) {
            NSArray* rows = [data objectForKey:@"rows"];
            NSMutableArray* streets = [NSMutableArray array];
            for (NSDictionary* entry in rows) {
                NSArray* keys = [entry objectForKey:@"key"];
                if (keys && [keys count] == 3) {
                    [streets addObject:[keys objectAtIndex:2]];
                }
            }
            return [[streets copy] autorelease];
        } else {
            NSLog(@"error parsing streets: %@", error);            
        }
    } else {
        NSLog(@"error reading streets: %@", error);
    }
    
    return [NSArray array];
}

// Array of BlackoutPeriod that match the street
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

-(NSArray*) groupsWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@?key=%@", 
                                       kBlackoutUrlBase, 
                                       kBlackoutDb, 
                                       kBlackoutMethodGroup, 
                                       [[NSString stringWithFormat:@"\"%@-%@-%@\"", prefecture, city, street] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                       ]];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:kBlackoutUsername];
    [request setPassword:kBlackoutPassword];
    [request setSecondsToCache:60*60];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSData *response = [request responseData];
        NSDictionary* data = [[CJSONDeserializer deserializer] deserializeAsDictionary:response 
                                                                                 error:&error];
        
        if (!error) {
            NSArray* rows = [data objectForKey:@"rows"];
            for (NSDictionary* entry in rows) {
                NSDictionary* value = [entry objectForKey:@"value"];
                return [value objectForKey:@"time"];
            }
        } else {
            NSLog(@"error parsing groups: %@", error);            
        }
    } else {
        NSLog(@"error reading groups: %@", error);
    }

    return nil;
}

-(NSArray*) periodsWithGroups:(NSArray*)groups {
    return [NSArray array];
}

@end
