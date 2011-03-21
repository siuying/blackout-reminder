//
//  BlackoutGroup.m
//  Blackout
//
//  Created by Francis Chong on 11年3月21日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import "BlackoutGroup.h"


@implementation BlackoutGroup

@synthesize company, code;

-(id) initWithCompany:(NSString*)aCompany code:(NSString*)aCode {
    self = [super init];
    self.company = aCompany;
    self.code = aCode;
    return self;
}

-(void) dealloc {
    self.company = nil;
    self.code = nil;
    [super dealloc];
}

@end
