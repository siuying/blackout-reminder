//
//  BlackoutGroup.h
//  Blackout
//
//  Created by Francis Chong on 11年3月21日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlackoutGroup : NSObject {
    NSString* company;
    NSString* code;
}

@property (nonatomic, retain) NSString* company;
@property (nonatomic, retain) NSString* code;

-(id) initWithCompany:(NSString*)company code:(NSString*)code;

@end
