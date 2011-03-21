//
//  ProgressView.h
//  Blackout
//
//  Created by Francis Chong on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressView : UIView {
    
}

+(ProgressView*) progressViewOnView:(UIView*)parentView animated:(BOOL)animated;
+(ProgressView*) progressViewOnView:(UIView*)parentView;
-(void)removeProgressView;
-(void)removeProgressView:(BOOL)animated;

@end
