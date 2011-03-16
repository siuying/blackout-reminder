//
//  PrefectureTableViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewController.h"
#import "BlackoutService.h"
#import "CityTableViewController.h"

@interface PrefectureTableViewController : LocationTableViewController {
}

-(id)initWithBlackoutServices:(id<BlackoutService>)service;
-(void) cancel;
@end
