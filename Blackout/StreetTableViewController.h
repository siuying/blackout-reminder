//
//  StreetTableViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewController.h"
#import "BlackoutService.h"

@interface StreetTableViewController : LocationTableViewController {
    NSString* prefecture;
    NSString* city;
    NSString* street;
}

@property (nonatomic, retain) NSString* prefecture;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* street;

- (id)initWithBlackoutServices:(id<BlackoutService>)service prefecture:(NSString*)prefecture city:(NSString*)city delegate:(id<LocationTableViewControllerDelegate>) delegate;
-(void) done;
@end
