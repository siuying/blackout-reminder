//
//  CityTableViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "CityTableViewController.h"


@implementation CityTableViewController

@synthesize prefecture;

- (id)initWithBlackoutServices:(id<BlackoutService>)service prefecture:(NSString*)thePrefecture delegate:(id<LocationTableViewControllerDelegate>) delegate{
    NSArray* cities = [service cities:thePrefecture];
    self = [super initWithBlackoutServices:service locations:cities delegate:delegate];
    self.title = @"市区郡";
    self.prefecture = thePrefecture;
    return self;
}

- (void)dealloc
{
    self.prefecture = nil;
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

    StreetTableViewController* cityController = [[StreetTableViewController alloc] initWithBlackoutServices:self.blackoutServices
                                                                                                 prefecture:self.prefecture
                                                                                                       city:selected
                                                                                                   delegate:self.locationDelegate];
    [self.navigationController pushViewController:cityController animated:YES];
    [cityController release];
}

@end
