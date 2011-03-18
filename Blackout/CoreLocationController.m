//
//  CoreLocationController.m
//  Blackout
//
//  Created by Alex Hui on 18/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import "CoreLocationController.h"


@implementation CoreLocationController
@synthesize locationManager, delegate;

- (id)init {
	self = [super init];
    
	if(self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease]; // Create new instance of locMgr
		self.locationManager.delegate = self; // Set the delegate as self.
	}
    
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  
		[self.delegate locationError:error];
	}
}

- (void)dealloc {
	[self.locationManager release];
	[super dealloc];
}

@end
