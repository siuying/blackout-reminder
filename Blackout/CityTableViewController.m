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
    self = [super initWithBlackoutServices:service locations:[NSArray array] delegate:delegate];
    self.prefecture = thePrefecture;
    self.title = [self title];
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
    if (self.loaded && !self.empty && !self.error) {
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
