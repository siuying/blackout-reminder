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

@protocol LocationServiceDelegate
-(void) findLocationName:(CLLocationCoordinate2D)location didFound:(NSArray*)names;
-(void) findLocationName:(CLLocationCoordinate2D)location didFailedWithError:(NSError*)error;
@end

@interface LocationService : NSObject <MKReverseGeocoderDelegate> { 
    id<LocationServiceDelegate> locationDelegate;
    MKReverseGeocoder* reverseGeocoder;
}

@property (nonatomic,assign) id<LocationServiceDelegate>    locationDelegate;
@property (nonatomic,retain) MKReverseGeocoder*             reverseGeocoder;

// Discard currently working location service
-(void) stop;

// use MKReverseGeocoder to find the prefecture, city and street of the specified location
// return array of strings of prefecture, city and street
-(void) findLocationName:(CLLocationCoordinate2D)coord;

@end
