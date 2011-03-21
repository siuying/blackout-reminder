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
#import "BlackoutGroup.h"

#define kBlackoutTepco      @"http://www.tepco.co.jp/index-j.html"
#define kBlackoutTimeApi    @"http://www.tepco.co.jp/index-j.html"

#define kBlackoutUrlBase    @"https://ignition.cloudant.com"
#define kBlackoutDb         @"blackout-dev"
#define kBlackoutUsername   @"behictingualdrionschaver"
#define kBlackoutPassword   @"lqNLPtLRyNDcW1nk4cT81SvP"

#define kBlackoutMethodPrefectures      @"_design/api/_view/prefectures?group=true"
#define kBlackoutMethodCities           @"_design/api/_view/cities"
#define kBlackoutMethodStreets          @"_design/api/_view/streets"
#define kBlackoutMethodGroup            @"_design/api/_view/blackout"
#define kBlackoutMethodSchedules        @"_design/api/_list/time/schedules"

@interface RemoteBlackoutService (Private)
-(NSArray*) periodsWithGroup:(BlackoutGroup*)group withDate:(NSDate*)date;
@end

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
                
                NSMutableArray* groups = [NSMutableArray array];
                NSString* company = [value objectForKey:@"company"];
                NSArray* groupCodes = [value objectForKey:@"group"];

                for (NSString* groupId in groupCodes) {
                    [groups addObject:[[BlackoutGroup alloc] initWithCompany:company code:groupId]];
                }
                return groups;
            }
        } else {
            NSLog(@"error parsing groups: %@", error);            
        }
    } else {
        NSLog(@"error reading groups: %@", error);
    }

    return [NSArray array];
}

-(NSArray*) periodsWithGroups:(NSArray*)groups withDate:(NSDate*)date {
    NSMutableArray* periods = [NSMutableArray array];

    for (BlackoutGroup* group in groups) {
        [periods addObjectsFromArray:[self periodsWithGroup:group 
                                                   withDate:date]];
    }    
    self.lastUpdated = [NSDate date];
    return periods;
}

#pragma Private

-(NSArray*) periodsWithGroup:(BlackoutGroup*)group withDate:(NSDate*)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString* dateString = [formatter stringFromDate:date];
    [formatter release];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@?key=%@", 
                                       kBlackoutUrlBase, 
                                       kBlackoutDb, 
                                       kBlackoutMethodSchedules, 
                                       [[NSString stringWithFormat:@"[\"%@\",\"%@\", \"%@\"]", group.company, group.code, dateString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                       ]];
    
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
    [request setUsername:kBlackoutUsername];
    [request setPassword:kBlackoutPassword];
    [request setSecondsToCache:60];
    [request setNumberOfTimesToRetryOnTimeout:3];
    [request startSynchronous];

    NSError *error = [request error];
    if (!error) {
        NSData *response = [request responseData];
        NSArray* rows = [[CJSONDeserializer deserializer] deserializeAsArray:response 
                                                                       error:&error];
        if (!error) {
            for (NSDictionary* entry in rows) {
                NSArray* time = [entry objectForKey:@"time"];
                if (time) {
                    NSMutableArray* periods = [NSMutableArray array];
                    for (NSArray* timeEntry in time) {
                        if ([time count] >= 2) {
                            NSString* fromTimeStr = [timeEntry objectAtIndex:0];
                            NSString* toTimeStr = [timeEntry objectAtIndex:1];
                        
                            BlackoutPeriod* period = [[BlackoutPeriod alloc] initWithGroup:group 
                                                                            fromTimeString:fromTimeStr 
                                                                              toTimeString:toTimeStr];
                            [periods addObject:period];
                            [period release];
                        }                        
                    }
                    return periods;
                } else {
                    NSLog(@" warning: period contain not time: %@", entry);
                }
            }
        } else {
            NSLog(@"error parsing periods: %@", error);            
        }
    } else {
        NSLog(@"error reading periods: %@", error);
    }
    return [NSArray array];
}

@end
