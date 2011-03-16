//
//  BlackoutAppDelegate.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutAppDelegate.h"

#import "BlackoutViewController.h"

@implementation BlackoutAppDelegate


@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize locationService;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.locationService = [[[LocationService alloc] init] autorelease];
    self.locationService.locationDelegate = self;

    // http://maps.google.com/?ie=UTF8&hq=&hnear=Hong+Kong&ll=35.715159,139.660435&spn=0.148436,0.161362&z=13&iwloc=lyrftr:m,0x6018ed6268296633:0xe455635896e1cf9d,35.719479,139.663696
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(35.715159, 139.660435);
    [self.locationService findLocationName:location];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    self.locationService = nil;

    [_window release];
    [_viewController release];
    [super dealloc];
}

#pragma LocationServiceDelegate

-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names {
    NSLog(@"location found: %@", names);
}

-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error {
}

@end
