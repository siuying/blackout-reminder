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
-(NSString*) headerValueAsString:(NSDate*)date;
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
    NSDate* date = [self.dates objectAtIndex:section];
    NSString* key = [self headerValueAsString:date];
    NSArray* dateArray = [self.dateTimes objectForKey:key];
    return [dateArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDate* date = [self.dates objectAtIndex:[indexPath indexAtPosition:0]];
    NSString* key = [self headerValueAsString:date];
    NSArray* section = [self.dateTimes objectForKey:key];
    BlackoutPeriod* period = [section objectAtIndex:[indexPath indexAtPosition:1]];
    cell.textLabel.text = [self cellValueAsString:period];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate* date = [self.dates objectAtIndex:section];
    return [self headerValueAsString:date];
}

-(void) cancel {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void) setup {   
    NSDate* now = [NSDate date];
    for (BlackoutPeriod* period in self.blackoutPeriods) {        
        if ([period.toTime compare:now] == NSOrderedDescending) {
            NSMutableArray* timeArray;
            NSString* key = [self headerValueAsString:period.fromTime];
            if ([self.dateTimes objectForKey:key] != nil) {
                timeArray = [self.dateTimes objectForKey:key];
            } else {
                [self.dates addObject:period.fromTime];
                timeArray = [NSMutableArray array];
                [self.dateTimes setValue:timeArray forKey:key];
            }
            [timeArray addObject:period];
        }
    }
    
    [self.dates sortUsingSelector:@selector(compare:)];
    
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

-(NSString*) headerValueAsString:(NSDate*)date {
    NSDateFormatter *dateFormatterDate = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatterDate setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatterDate setDateStyle:NSDateFormatterShortStyle];
    return [dateFormatterDate stringFromDate:date];
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
