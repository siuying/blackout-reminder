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

+(ProgressView*) progressViewOnView:(UIView*)parentView {
    ProgressView* progressView = [[[ProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    progressView.alpha = 0;
    [parentView addSubview:progressView];
    [parentView bringSubviewToFront:progressView];

    [UIView animateWithDuration:0.3 
                     animations:^{
                         progressView.alpha = 1;
                     } 
                     completion:^(BOOL finished){
                     }
     ];
    
    return progressView;
}

-(void)removeProgressView {
    [UIView animateWithDuration:0.3 
                     animations:^{
                         self.alpha = 0;
                     } 
                     completion:^(BOOL finished){
                         self.hidden = YES;
                         [self removeFromSuperview];
                     }
     ];

}
@end
