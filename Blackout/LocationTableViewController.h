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
    BOOL error;
    BOOL loaded;
    
    NSMutableArray* locations;
    id<BlackoutService> blackoutServices;
    id<LocationTableViewControllerDelegate> locationDelegate;
    
    UIActivityIndicatorView* loadingView;
}

@property (nonatomic, retain)    NSMutableArray* locations;
@property (nonatomic, retain)    id<BlackoutService> blackoutServices;
@property (nonatomic, assign)    id<LocationTableViewControllerDelegate> locationDelegate;
@property (nonatomic, retain)    UIActivityIndicatorView* loadingView;

@property (nonatomic, assign)    BOOL error;
@property (nonatomic, assign)    BOOL loaded;
@property (nonatomic, readonly)  BOOL empty;

- (id)initWithBlackoutServices:(id<BlackoutService>)service locations:(NSArray*)locations delegate:(id<LocationTableViewControllerDelegate>) delegate;

-(void) loadTable;
-(void) setLoading:(BOOL)loading;
-(void) setError:(BOOL)isError message:(NSString*)message;

// If the table is loaded and empty
-(BOOL) empty;

-(NSString*) title;

@end
