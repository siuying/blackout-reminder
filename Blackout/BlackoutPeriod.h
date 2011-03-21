//
//  BlackoutPeriod.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlackoutGroup.h"

@interface BlackoutPeriod : NSObject {
    BlackoutGroup* group;
    NSDateComponents* fromTime;
    NSDateComponents* toTime;
}

@property (nonatomic, retain) BlackoutGroup* group;
@property (nonatomic, retain) NSDateComponents* fromTime;
@property (nonatomic, retain) NSDateComponents* toTime;

-(id) initWithGroup:(BlackoutGroup*)group fromTimeString:(NSString*)fromTimeString toTimeString:(NSString*)toTimeString;

@end
