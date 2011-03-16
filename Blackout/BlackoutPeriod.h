//
//  BlackoutPeriod.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlackoutPeriod : NSObject {
    NSDate* fromTime;
    NSDate* toTime;
}

@property (nonatomic, retain) NSDate* fromTime;
@property (nonatomic, retain) NSDate* toTime;

@end
