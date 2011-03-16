//
//  BlackoutViewController.h
//  Blackout
//
//  Created by Francis Chong on 11年3月16日.
//  Copyright 2011年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlackoutViewController : UIViewController {
    IBOutlet UILabel* lblPrefecture;
    IBOutlet UILabel* lblCity;
    IBOutlet UILabel* lblStreet;
}


@property (nonatomic, retain) IBOutlet UILabel* lblPrefecture;
@property (nonatomic, retain) IBOutlet UILabel* lblCity;
@property (nonatomic, retain) IBOutlet UILabel* lblStreet;

@end
