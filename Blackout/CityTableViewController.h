//
//  CityTableViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewController.h"
#import "StreetTableViewController.h"
#import "BlackoutService.h"

@interface CityTableViewController : LocationTableViewController {
    NSString* prefecture;
}
@property (nonatomic, retain)     NSString* prefecture;

- (id)initWithBlackoutServices:(id<BlackoutService>)service prefecture:(NSString*)prefecture delegate:(id<LocationTableViewControllerDelegate>) delegate;

@end
