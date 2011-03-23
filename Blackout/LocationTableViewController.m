//
//  LocationTableViewController.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "LocationTableViewController.h"

@interface LocationTableViewController (Private)
-(void) setSearchBarSelected:(BOOL)selected;
@end

@implementation LocationTableViewController

@synthesize loadingView, searchBar;
@synthesize locations, error, loaded;
@synthesize blackoutServices;
@synthesize locationDelegate;

@synthesize searchTerm, filteredLocations;

- (id)initWithBlackoutServices:(id<BlackoutService>)theService locations:(NSArray*)theLocations delegate:(id<LocationTableViewControllerDelegate>) delegate{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.locationDelegate = delegate;
        self.blackoutServices = theService;
        
        self.locations = [NSMutableArray arrayWithArray:[theLocations sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        self.filteredLocations = nil;
    }
    return self;
}


- (void)dealloc
{
    self.searchTerm = nil;
    self.filteredLocations = nil;
    self.blackoutServices = nil;
    self.locations = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private

// animate UI when user select search bar
-(void) setSearchBarSelected:(BOOL)selected {
    if (selected) {
        [self.searchBar setShowsCancelButton:YES animated:YES];
        
    } else {
        [self.searchBar setShowsCancelButton:NO animated:YES];
        
    }
}

#pragma mark - View lifecycle

-(void) loadView {
    [super loadView];

    [self loadTable];
    self.tableView.autoresizesSubviews = YES;
    
    self.searchBar = [[[UISearchBar alloc] init] autorelease];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];

    self.tableView.tableHeaderView = self.searchBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loadingView = nil;
    self.searchBar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setSearchBarSelected:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public

-(void) loadTable {
}

-(void) setLoading:(BOOL)loading {
    NSLog(@" loading table: %@", loading ? @"YES" : @"NO");
    if (loading) {
        if (!self.loadingView) {
            self.loadingView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        }
        
        [self.loadingView startAnimating];
        self.navigationItem.titleView = self.loadingView;
        self.loaded = NO;

    } else {
        if (self.loadingView) {
            [self.loadingView stopAnimating];
            [self.loadingView removeFromSuperview];
            self.navigationItem.titleView = nil;
            self.loadingView = nil;
            self.loaded = YES;
        }        
    }
    self.navigationItem.leftBarButtonItem.enabled = !loading;
    self.navigationItem.rightBarButtonItem.enabled = !loading;
    [self.navigationController.navigationBar setNeedsDisplay];
}

-(NSString*) title {
    return @"";
}

-(void) setError:(BOOL)isError message:(NSString*)message {
    self.error = isError;
    if (isError) {
        
    } else {
        
    }
}

-(BOOL) empty {
    return [locations count] == 0 && loaded;
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.error) {
        return 1;
    } else if (self.empty) {
        return 1;
    } else {
        if (self.filteredLocations) {
            return [self.filteredLocations count];
        } else {
            return [locations count];        
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (self.error) {
        cell.textLabel.text = @"データのダウンロードにエラーが発生しました";        
        cell.textLabel.textColor = [UIColor redColor];
    } else if (self.empty) {
        cell.textLabel.text = @"検索エラー";
        cell.textLabel.textColor = [UIColor darkGrayColor];
    } else {
        cell.textLabel.text = [self textForRow:indexPath];        
        cell.textLabel.textColor = [UIColor darkTextColor];
    }

    return cell;
}

-(NSString*) textForRow:(NSIndexPath *)indexPath {
    if (self.filteredLocations) {
        return [filteredLocations objectAtIndex:[indexPath indexAtPosition:1]];        
    } else {
        return [locations objectAtIndex:[indexPath indexAtPosition:1]];        
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self setSearchBarSelected:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self setSearchBarSelected:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@" cancel clicked");
    [self setSearchBarSelected:NO];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)aSearchTerm {
    if (![self.searchTerm isEqualToString:aSearchTerm] && self.loaded) {
        NSLog(@"search term = %@", aSearchTerm);
        self.searchTerm = aSearchTerm;

        if (aSearchTerm != nil && ![aSearchTerm isEqualToString:@""]) {
            self.filteredLocations = [NSMutableArray arrayWithArray:self.locations];
            for (NSString* loc in self.locations) {
                if ([loc rangeOfString:aSearchTerm options:NSLiteralSearch|NSCaseInsensitiveSearch].location == NSNotFound) {
                    [self.filteredLocations removeObject:loc];
                } else {
                    NSLog(@" %@", loc);
                }
            }
            
        } else {
            self.filteredLocations = nil;
        }
        [self.tableView reloadData];
    }
}

@end
