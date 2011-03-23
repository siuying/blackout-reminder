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
-(NSString*) cellValueAsString:(BlackoutPeriod*)period;
@end


@implementation BlackoutTableViewController
@synthesize blackoutPeriods, dates, dateTimes;

-(id) initWithBlackoutPeriods:(NSArray *)periods {
    self = [super initWithStyle:UITableViewStylePlain];
    self.blackoutPeriods = periods;

    self.dates = [NSMutableArray array];
    self.dateTimes = [NSMutableDictionary dictionary];
    [self setup];

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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString* date = [self.dates objectAtIndex:[indexPath indexAtPosition:0]];
    NSArray* section = [self.dateTimes objectForKey:date];
    BlackoutPeriod* period = [section objectAtIndex:[indexPath indexAtPosition:1]];
    cell.textLabel.text = [self cellValueAsString:period];
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
        NSMutableArray* timeArray;
        if ([self.dateTimes objectForKey:date] != nil) {
            timeArray = [self.dateTimes objectForKey:date];
        } else {
            timeArray = [NSMutableArray array];
            [self.dates addObject:date];
            [self.dateTimes setValue:timeArray forKey:date];
        }
        [timeArray addObject:period];
    }
    
    [self.dates sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSMutableArray* sectionArr in [self.dateTimes objectEnumerator]) {
        [sectionArr sortUsingComparator:(NSComparator)^(id obj1, id obj2){
            BlackoutPeriod* p1 = obj1;
            BlackoutPeriod* p2 = obj2;
            NSDate* toDate1 = p1.toTime;
            NSDate* toDate2 = p2.toTime;
            return [toDate1 compare:toDate2]; 
        }];    
    }
}

-(NSString*) cellValueAsString:(BlackoutPeriod*)period {
    NSDateFormatter *dateFormatterTime = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatterTime setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatterTime setDateStyle:NSDateFormatterNoStyle];

    NSString* time = [NSString stringWithFormat:@"%@ ～ %@", 
                      [dateFormatterTime stringFromDate:period.fromTime], 
                      [dateFormatterTime stringFromDate:period.toTime]];
    return time;
}

@end
