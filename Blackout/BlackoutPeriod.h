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
    NSString* message;
    NSDate* fromTime;
    NSDate* toTime;
}

@property (nonatomic, retain) BlackoutGroup* group;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSDate* fromTime;
@property (nonatomic, retain) NSDate* toTime;

-(id) initWithGroup:(BlackoutGroup*)group fromTime:(NSDate*)fromTime toTime:(NSDate*)toTime  message:(NSString*)message ;

@end
