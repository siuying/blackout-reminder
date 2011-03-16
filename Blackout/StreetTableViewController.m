//
//  StreetTableViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "StreetTableViewController.h"


@implementation StreetTableViewController

@synthesize prefecture, city, street;

- (id)initWithBlackoutServices:(id<BlackoutService>)theService prefecture:(NSString*)thePrefecture city:(NSString*)theCity delegate:(id<LocationTableViewControllerDelegate>) delegate{
    NSArray* streets = [theService streetsWithPrefecture:thePrefecture city:theCity];
    self = [super initWithBlackoutServices:theService locations:streets delegate:delegate];
    self.title = @"大字通称";
    self.prefecture = thePrefecture;
    self.city = theCity;
    return self;
}

- (void)dealloc
{
    self.street = nil;
    self.prefecture = nil;
    self.city = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self 
                                                                                           action:@selector(done)] autorelease];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void) done {
    [self.locationDelegate locationDidSelectedWithPrefecture:self.prefecture city:self.city street:self.street];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // find selected index
    self.street = [self.locations objectAtIndex:[indexPath indexAtPosition:1]];
    NSLog(@" selected: %@", street);    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

@end
