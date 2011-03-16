//
//  LocationTableViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackoutService.h"

@interface LocationTableViewController : UITableViewController {
    NSArray* locations;
    id<BlackoutService> blackoutServices;
}

@property (nonatomic, retain)    NSArray* locations;
@property (nonatomic, retain)    id<BlackoutService> blackoutServices;

- (id)initWithBlackoutServices:(id<BlackoutService>)service locations:(NSArray*)locations;

@end
