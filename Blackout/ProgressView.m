//
//  ProgressView.m
//  Blackout
//
//  Created by Francis Chong on 11年3月18日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "ProgressView.h"


@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView* activity = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(142, 221, 37, 37)] autorelease];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activity.hidden = NO;
        [activity startAnimating];
        [self addSubview:activity];
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.opaque = NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark Public

+(ProgressView*) progressViewOnView:(UIView*)parentView animated:(BOOL)animated {
    ProgressView* progressView = [[[ProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    progressView.alpha = 0;
    [parentView addSubview:progressView];
    [parentView bringSubviewToFront:progressView];
    
    if (animated) {
        [UIView animateWithDuration:0.3 
                         animations:^{
                             progressView.alpha = 1;
                         } 
                         completion:^(BOOL finished){
                         }
         ];
    } else {
        progressView.alpha = 1;
    }

    return progressView;
}

+(ProgressView*) progressViewOnView:(UIView*)parentView {
    return [ProgressView progressViewOnView:parentView animated:YES];
}

-(void)removeProgressView {
    [self removeProgressView:YES];
}

-(void)removeProgressView:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 
                         animations:^{
                             self.alpha = 0;
                         } 
                         completion:^(BOOL finished){
                             self.hidden = YES;
                             [self removeFromSuperview];
                         }
         ];
    } else {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

@end
