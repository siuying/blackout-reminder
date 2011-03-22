//
//  RemaingTimeTitleView.m
//  Blackout
//
//  Created by Alex Hui on 17/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import "RemaingTimeTitleView.h"

@interface RemaingTimeTitleView (Private)
- (UILabel *)labelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation RemaingTimeTitleView
@synthesize appTitle, remainingTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 200, 44);
        self.appTitle = [self labelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:20.0 bold:YES];
        self.appTitle.frame = CGRectMake(0, 0, 200, 28);
        self.appTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.appTitle.textAlignment = UITextAlignmentCenter;
        self.appTitle.backgroundColor = [UIColor clearColor];
        self.appTitle.text = [NSString stringWithFormat:@"計画停電"];
        
        [self addSubview:self.appTitle];
        
    }
    return self;
}

- (void) setLastUpdatedTime:(NSDate*) update {
    if (update) {
        if (!self.remainingTime) {
            self.remainingTime = [self labelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:11.0 bold:NO];
            self.remainingTime.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.remainingTime.textAlignment = UITextAlignmentCenter;
            self.remainingTime.backgroundColor = [UIColor clearColor];
            [self addSubview:self.remainingTime];            
        }

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM dd, HH:mm"];
        NSString *lastUpdatedString = [dateFormatter stringFromDate:update];
        self.remainingTime.text = [NSString stringWithFormat:@"更新時間：%@", lastUpdatedString];
        [dateFormatter release];
    } else {
        [self.remainingTime removeFromSuperview];
        self.remainingTime = nil;
    }
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    if (self.remainingTime) {
        self.appTitle.frame = CGRectMake(0, 0, 200, 28);
        self.remainingTime.frame = CGRectMake(0, 26, 200, 15);
    } else {
        self.appTitle.frame = CGRectMake(0, 0, 200, 44);
        self.remainingTime.frame = CGRectZero; 
    }
}

- (void)dealloc
{
    self.remainingTime = nil;
    self.appTitle = nil;
    [super dealloc];
}

#pragma Private

- (UILabel *)labelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold {
	UIFont *font;
	if (bold) {
		font = [UIFont boldSystemFontOfSize:fontSize];
	} else {
		font = [UIFont systemFontOfSize:fontSize];
	}

	UILabel *newLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	newLabel.backgroundColor = [UIColor blackColor];
	newLabel.opaque = NO;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

@end
