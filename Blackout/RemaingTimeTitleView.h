//
//  RemaingTimeTitleView.h
//  Blackout
//
//  Created by Alex Hui on 17/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemaingTimeTitleView : UIView {
    
    UILabel* appTitle;
    UILabel* remainingTime;
    
}
@property(nonatomic,retain) UILabel* appTitle;
@property(nonatomic,retain) UILabel* remainingTime;

-(void) setLastUpdatedTime: (NSDate*) update;

@end
