//
//  BlackoutUtils.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlackoutUtils : NSObject {
}

// find next blackout time with current time and array of blackout period
+(NSDate*) nextBlackoutWithCurrentTime:(NSDate*)currentTime
                                period:(NSArray*)periods;

@end
