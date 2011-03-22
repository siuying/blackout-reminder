//
//  LocationService.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BlackoutService.h"

@protocol LocationServiceDelegate
-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names;
-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error;
-(void) findLocationDidFailedWithError:(NSError*)error;
@end

@interface LocationService : NSObject <MKReverseGeocoderDelegate, CLLocationManagerDelegate> { 
    id<LocationServiceDelegate> locationDelegate;

    CLLocationManager *locationManager;
    MKReverseGeocoder* reverseGeocoder;
    id<BlackoutService> blackoutService;
}

@property (nonatomic,assign) id<LocationServiceDelegate>    locationDelegate;

@property (nonatomic, retain) CLLocationManager*            locationManager;
@property (nonatomic, retain) id<BlackoutService>           blackoutService;
@property (nonatomic, retain) MKReverseGeocoder*            reverseGeocoder;

-(id) initWithBlackoutService:(id<BlackoutService>)service;

// Discard currently working location service
-(void) stop;

// Find current location
-(void) findLocation;

// use MKReverseGeocoder to find the prefecture, city and street of the specified location
// return array of strings of prefecture, city and street
-(void) findLocationName:(CLLocationCoordinate2D)coord;


@end
