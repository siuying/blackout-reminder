//
//  BlackoutService.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlackoutPeriod.h"

@protocol BlackoutService <NSObject>

// when this blackout service being updated
-(NSDate*) lastUpdated;

// Find list of prefectures
-(NSArray*) prefectures;

// Find list of cities by prefecture
-(NSArray*) cities:(NSString*)prefecture;

// Find list of street by prefecture and city
-(NSArray*) streetsWithPrefecture:(NSString*)prefecture city:(NSString*)city;

// Array of BlackoutGroup that match the prefecture, city and street
// If no groups found, return empty array
-(NSArray*) groupsWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street;

// Array of BlackoutPeriod from the groups
// If no electricity for the groups found, return empty array
-(NSArray*) periodsWithGroups:(NSArray*)groups;

-(NSArray*) validatePrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street;

@end
