//
//  LocationService.m
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "LocationService.h"


@implementation LocationService

@synthesize locationDelegate, locationManager, reverseGeocoder;

-(id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) dealloc {
    [self stop];

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
    NSArray* location = [NSArray arrayWithObjects:placemark.administrativeArea, placemark.locality, placemark.subLocality, nil];
    
    NSLog(@"placemark: %@", placemark);
    [self.locationDelegate findLocationName:geocoder.coordinate 
                                   didFound:location];
}

// There are at least two types of errors:
//   - Errors sent up from the underlying connection (temporary condition)
//   - Result not found errors (permanent condition).  The result not found errors
//     will have the domain MKErrorDomain and the code MKErrorPlacemarkNotFound
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    [self.locationDelegate findLocationName:geocoder.coordinate 
                         didFailedWithError:error];
}

#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self findLocationName:newLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationDelegate findLocationDidFailedWithError:error];
}

@end
