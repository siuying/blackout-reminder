//
//  BlackoutPeriod.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlackoutPeriod : NSObject {
    NSDateComponents* fromTime;
    NSDateComponents* toTime;
}

@property (nonatomic, retain) NSDateComponents* fromTime;
@property (nonatomic, retain) NSDateComponents* toTime;

@end
