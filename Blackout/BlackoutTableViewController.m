//
//  BlackoutTableViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月23日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutTableViewController.h"
#import "BlackoutUtils.h"

@interface BlackoutTableViewController (Private)
-(void) setup;
@end


@implementation BlackoutTableViewController
@synthesize blackoutPeriods, dates, dateTimes;

-(id) initWithBlackoutPeriods:(NSArray *)periods {
    self = [super initWithStyle:UITableViewStylePlain];
    self.blackoutPeriods = periods;

    self.dates = [NSMutableArray array];
    self.dateTimes = [NSMutableDictionary dictionary];
    [self setup];
    
    if ([periods count] > 0) {
        BlackoutPeriod* period = [periods objectAtIndex:0];
        self.title = [NSString stringWithFormat:@"第%@グループ", period.group.code];
    } else {
        self.title = @"計画停電";
    }
    return self;
}

-(void) dealloc {
    self.dates = nil;
    self.dateTimes = nil;
    self.blackoutPeriods = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self 
                                                                                           action:@selector(cancel)] autorelease];
}

#pragma mark - Table View Controller


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* date = [self.dates objectAtIndex:section];
    NSArray* dateArray = [dateTimes objectForKey:date];
    return [dateArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString* date = [self.dates objectAtIndex:[indexPath indexAtPosition:0]];
    NSArray* section = [self.dateTimes objectForKey:date];
    NSString* period = [section objectAtIndex:[indexPath indexAtPosition:1]];
    cell.textLabel.text = period;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* date = [self.dates objectAtIndex:section];
    return date;
}

-(void) cancel {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void) setup {
    NSDateFormatter *dateFormatterDate = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatterDate setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatterDate setDateStyle:NSDateFormatterShortStyle];
    
    NSDateFormatter *dateFormatterTime = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatterTime setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatterTime setDateStyle:NSDateFormatterNoStyle];
   
    for (BlackoutPeriod* period in self.blackoutPeriods) {
        NSString* date = [dateFormatterDate stringFromDate:period.fromTime];
        NSString* time = [NSString stringWithFormat:@"%@ ～ %@", 
                          [dateFormatterTime stringFromDate:period.fromTime], 
                          [dateFormatterTime stringFromDate:period.toTime]];
        
        NSMutableArray* timeArray;
        if ([self.dateTimes objectForKey:date] != nil) {
            timeArray = [self.dateTimes objectForKey:date];
        } else {
            timeArray = [NSMutableArray array];
            [self.dates addObject:date];
            [self.dateTimes setValue:timeArray forKey:date];
        }
        [timeArray addObject:time];
    }
}

@end
