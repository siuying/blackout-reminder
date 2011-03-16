//
//  PrefectureTableViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "PrefectureTableViewController.h"

@implementation PrefectureTableViewController

- (id)initWithBlackoutServices:(id<BlackoutService>)theService delegate:(id<LocationTableViewControllerDelegate>) delegate
{
    NSArray* prefectures = [theService prefectures];
    self = [super initWithBlackoutServices:theService locations:prefectures delegate:delegate];
    self.title = @"都県";
    return self;
}

-(void) cancel {
    [self.locationDelegate locationDidCancelled];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self 
                                                                                           action:@selector(cancel)] autorelease];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // find selected index
    NSString* selected = [self.locations objectAtIndex:[indexPath indexAtPosition:1]];
    NSLog(@" selected: %@", selected);

    CityTableViewController* cityController = [[CityTableViewController alloc] initWithBlackoutServices:self.blackoutServices prefecture:selected delegate:self.locationDelegate];
    [self.navigationController pushViewController:cityController animated:YES];
    [cityController release];
}

@end
