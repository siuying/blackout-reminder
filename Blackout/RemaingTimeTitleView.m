//
//  RemaingTimeTitleView.m
//  Blackout
//
//  Created by Alex Hui on 17/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import "RemaingTimeTitleView.h"


@implementation RemaingTimeTitleView
@synthesize appTitle, remainingTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 250, 44);
        appTitle = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:20.0 bold:YES];
        appTitle.frame = CGRectMake(0, 0, 250, 28);
        appTitle.textAlignment = UITextAlignmentCenter;
        appTitle.backgroundColor = [UIColor clearColor];
        appTitle.text = [NSString stringWithFormat:@"計画停電"];
    
        /*
        remainingTime = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:13.0 bold:YES];
        remainingTime.frame = CGRectMake(0, 28, 250, 15);
        remainingTime.textAlignment = UITextAlignmentCenter;
        remainingTime.backgroundColor = [UIColor clearColor];
        remainingTime.text = [NSString stringWithFormat:@"計画"];
        */
        
        [self addSubview:appTitle];
        
        
    }
    return self;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	UIFont *font;
	if (bold) {
		font = [UIFont boldSystemFontOfSize:fontSize];
	} else {
		font = [UIFont systemFontOfSize:fontSize];
	}
    
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor blackColor];
	newLabel.opaque = NO;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}

- (void) lastUpdatedTime: (NSDate*) update {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, HH:mm"];
    NSString *lastUpdatedString = [dateFormatter stringFromDate:update];
    
    remainingTime = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:13.0 bold:YES];
    remainingTime.frame = CGRectMake(0, 28, 250, 15);
    remainingTime.textAlignment = UITextAlignmentCenter;
    remainingTime.backgroundColor = [UIColor clearColor];
    remainingTime.text = [NSString stringWithFormat:@"更新時間：%@", lastUpdatedString];
    
    [self addSubview:remainingTime];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
