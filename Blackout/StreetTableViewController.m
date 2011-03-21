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
    self = [super initWithBlackoutServices:theService locations:[NSArray array] delegate:delegate];
    self.title = [self title];
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

#pragma mark - LocationTableViewController

-(void) loadTable {
    [self setLoading:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        NSArray* streets = [self.blackoutServices streetsWithPrefecture:self.prefecture city:self.city];
        [self.locations removeAllObjects];
        [self.locations addObjectsFromArray:streets];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLoading:NO];
            [self.tableView reloadData];
        });
    });
}

-(void) setLoading:(BOOL)loading {
    [super setLoading:loading];
    self.navigationItem.rightBarButtonItem.enabled = !loading && self.street;
}

-(NSString*) title {
    return @"大字通称";
}


@end
