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

-(NSDate*) lastUpdated;

-(NSArray*) prefectures;
-(NSArray*) cities:(NSString*)prefecture;
-(NSArray*) streets:(NSString*)city;

-(BlackoutPeriod*) periodWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street;

@end
