//
//  LocationService.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "LocationService.h"


@implementation LocationService

@synthesize locationDelegate, locationManager, blackoutService, reverseGeocoder;

-(id) initWithBlackoutService:(id<BlackoutService>)service {
    self = [super init];
    if (self) {
        self.blackoutService = service;
    }
    return self;
}

-(void) dealloc {
    [self stop];

    self.blackoutService = nil;
    self.locationManager = nil;
    self.reverseGeocoder = nil;
    [super dealloc];
}

-(void) stop {
    [self.reverseGeocoder cancel];
    [self.locationManager stopUpdatingLocation];
}

#pragma Public

-(void) findLocation {
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

-(void) findLocationName:(CLLocationCoordinate2D)coord {
    if (self.reverseGeocoder) {
        [self.reverseGeocoder cancel];
    }
    
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:coord] autorelease];    
    self.reverseGeocoder.delegate = self;
    [self.reverseGeocoder start];
}

#pragma MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSLog(@" placemark: %@, begin validation", placemark);    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray* locations = [self.blackoutService validatePrefecture:placemark.administrativeArea 
                                                                 city:placemark.locality 
                                                               street:[NSString stringWithFormat:@"%@%@", placemark.subLocality, placemark.thoroughfare]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationDelegate findLocationName:geocoder.coordinate 
                                           didFound:locations];
        });        
    });
}

// There are at least two types of errors:
//   - Errors sent up from the underlying connection (temporary condition)
//   - Result not found errors (permanent condition).  The result not found errors
//     will have the domain MKErrorDomain and the code MKErrorPlacemarkNotFound
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationDelegate findLocationName:geocoder.coordinate 
                             didFailedWithError:error];
    });
}

#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    [self findLocationName:newLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.locationDelegate findLocationDidFailedWithError:error];
    });
}

@end
