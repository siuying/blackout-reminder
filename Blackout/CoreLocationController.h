//
//  CoreLocationController.h
//  Blackout
//
//  Created by Alex Hui on 18/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required
-(void)locationUpdate:(CLLocation *)location;
-(void)locationError:(NSError *)error;
@end


@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id delegate;
@end
