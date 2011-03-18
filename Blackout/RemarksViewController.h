//
//  RemarksViewController.h
//  Blackout
//
//  Created by Alex Hui on 18/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemarksViewController : UIViewController {
    
    IBOutlet UIWebView* remarksWebView;
    
}
@property (nonatomic, retain) IBOutlet UIWebView* remarksWebView;
@end
