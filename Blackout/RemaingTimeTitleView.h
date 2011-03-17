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

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
- (void) lastUpdatedTime: (NSDate*) update;

@end
