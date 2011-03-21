//
//  BlackoutAppDelegate.m
//  Blackout
//
//  Created by Francis Chong on 11Âπ¥3Êúà16Êó•.
//  Copyright 2011Âπ¥ Ignition Soft Limited. All rights reserved.
//

#import "BlackoutAppDelegate.h"

#import "BlackoutViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface BlackoutAppDelegate (Private)
-(void) saveConfig;
@end

@implementation BlackoutAppDelegate


@synthesize window=_window;
@synthesize viewController=_viewController;
@synthesize prefectureName, cityName, streetName;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	self.prefectureName = [prefs objectForKey:PREFECTURE_KEY];
	self.cityName = [prefs objectForKey:CITY_KEY];
	self.streetName = [prefs objectForKey:STREET_KEY];
    
    [ASIHTTPRequest setDefaultTimeOutSeconds:30];
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
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
    [self saveConfig];
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
    [self saveConfig];    
}

- (void)dealloc
{
    
    [_window release];
    [_viewController release];
    [super dealloc];
}

#pragma mark Persistence of Prefecture,City and Street names

+(void)setPrefectureName:(NSString*)newPrefecture{
    BlackoutAppDelegate* delegate = (BlackoutAppDelegate*) [UIApplication sharedApplication].delegate;
	delegate.prefectureName = newPrefecture;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:newPrefecture forKey:PREFECTURE_KEY];
	[prefs synchronize];
    
}

+(NSString*)prefectureName {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:PREFECTURE_KEY];    
}

+(void)setCityName:(NSString*)newCity {
    BlackoutAppDelegate* delegate = (BlackoutAppDelegate*) [UIApplication sharedApplication].delegate;
	delegate.cityName = newCity;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:newCity forKey:CITY_KEY];
	[prefs synchronize];
    
}

+(NSString*)cityName {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:CITY_KEY];

}

+(void)setStreetName:(NSString*)newStreet {    
    BlackoutAppDelegate* delegate = (BlackoutAppDelegate*) [UIApplication sharedApplication].delegate;
	delegate.streetName = newStreet;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:newStreet forKey:STREET_KEY];
	[prefs synchronize];
    
}

+(NSString*)streetName {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:STREET_KEY];
}

-(void) saveConfig {    
    if (self.viewController.selectedPrefecture)
        [BlackoutAppDelegate setPrefectureName:self.viewController.selectedPrefecture];
    
    if (self.viewController.selectedCity)
        [BlackoutAppDelegate setCityName:self.viewController.selectedCity];
    
    if (self.viewController.selectedStreet)
        [BlackoutAppDelegate setStreetName:self.viewController.selectedStreet];
}

@end
