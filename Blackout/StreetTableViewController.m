//
//  StreetTableViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "StreetTableViewController.h"


@implementation StreetTableViewController

@synthesize prefecture, city;

- (id)initWithBlackoutServices:(id<BlackoutService>)theService prefecture:(NSString*)thePrefecture city:(NSString*)theCity{
    NSArray* streets = [theService streetsWithPrefecture:thePrefecture city:theCity];
    self = [super initWithBlackoutServices:theService locations:streets];
    self.title = @"大字通称";
    self.prefecture = thePrefecture;
    self.city = theCity;
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // find selected index
    NSString* selected = [self.locations objectAtIndex:[indexPath indexAtPosition:1]];
    NSLog(@" selected: %@", selected);
    
    // TODO
    // set the values
    // callback parent to dismiss the dialog?
}

@end
