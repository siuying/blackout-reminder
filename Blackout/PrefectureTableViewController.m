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
    self = [super initWithBlackoutServices:theService locations:[NSArray array] delegate:delegate];
    self.title = [self title];
    return self;
}

-(void) cancel {
    [self.locationDelegate locationDidCancelled];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchBar.placeholder = @"都県";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self 
                                                                                           action:@selector(cancel)] autorelease];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.loaded && !self.empty && !self.error) {
        // find selected index
        NSString* selected = [self textForRow:indexPath];
        NSLog(@" selected: %@", selected);
        
        CityTableViewController* cityController = [[CityTableViewController alloc] initWithBlackoutServices:self.blackoutServices prefecture:selected delegate:self.locationDelegate];
        [self.navigationController pushViewController:cityController animated:YES];
        [cityController release];
        
    }
}

#pragma mark - LocationTableViewController

-(void) loadTable {
    [self setLoading:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        NSArray* prefectures = [self.blackoutServices prefectures];
        self.locations = [NSMutableArray arrayWithArray:[prefectures sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            [self.tableView reloadData];
        });
    });
}

-(NSString*) title {
    return @"都県";
}

@end
