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
@synthesize city;

- (id)initWithBlackoutServices:(id<BlackoutService>)service prefecture:(NSString*)thePrefecture delegate:(id<LocationTableViewControllerDelegate>) delegate{
    self = [super initWithBlackoutServices:service locations:[NSArray array] delegate:delegate];
    self.prefecture = thePrefecture;
    self.title = [self title];
    return self;
}

- (void)dealloc
{
    self.city = nil;
    self.prefecture = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"検索：市区郡";
}

-(void) done {
    [self.locationDelegate locationDidSelectedWithPrefecture:self.prefecture city:self.city street:nil];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (self.loaded && !self.empty && !self.error) {
        NSString* selected = [self textForRow:indexPath];
        self.city = selected;
        [self done];
    }
}


#pragma mark - LocationTableViewController

-(void) loadTable {
    [self setLoading:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        NSArray* theCities = [self.blackoutServices cities:self.prefecture];
        self.locations = [NSMutableArray arrayWithArray:[theCities sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            [self.tableView reloadData];
        });
    });
}

-(NSString*) title {
    return self.prefecture == nil ? @"市区郡" : self.prefecture;
}


@end
