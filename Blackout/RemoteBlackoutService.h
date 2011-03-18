//
//  RemoteBlackoutService.h
//  Blackout
//
//  Created by Chong Francis on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlackoutService.h"

@interface RemoteBlackoutService : NSObject <BlackoutService> {
    NSDate* lastUpdated;
}

@property (nonatomic, retain) NSDate* lastUpdated;

@end
