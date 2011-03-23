//
//  BlackoutTableViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月23日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlackoutTableViewController : UITableViewController {
    NSArray* blackoutPeriods;
    
    NSMutableArray* dates;
    NSMutableDictionary* dateTimes;
}

@property (nonatomic, retain) NSArray* blackoutPeriods;

@property (nonatomic, retain) NSMutableArray* dates;
@property (nonatomic, retain) NSMutableDictionary* dateTimes;

-(id) initWithBlackoutPeriods:(NSArray*)periods;
-(void) cancel;

@end
