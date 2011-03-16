//
//  LocationTableViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackoutService.h"

@protocol LocationTableViewControllerDelegate
-(void) locationDidSelectedWithPrefecture:(NSString*)prefecture city:(NSString*)city street:(NSString*)street;
-(void) locationDidCancelled;
@end

@interface LocationTableViewController : UITableViewController {
    NSArray* locations;
    id<BlackoutService> blackoutServices;
    id<LocationTableViewControllerDelegate> locationDelegate;
}

@property (nonatomic, retain)    NSArray* locations;
@property (nonatomic, retain)    id<BlackoutService> blackoutServices;
@property (nonatomic, assign)    id<LocationTableViewControllerDelegate> locationDelegate;

- (id)initWithBlackoutServices:(id<BlackoutService>)service locations:(NSArray*)locations delegate:(id<LocationTableViewControllerDelegate>) delegate;

@end
