//
//  TepcoURLViewController.h
//  Blackout
//
//  Created by Alex Hui on 17/03/2011.
//  Copyright 2011 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TepcoURLViewController : UIViewController {
    
    IBOutlet UIWebView* webView;
    IBOutlet UINavigationBar *navigationBar;
    
}
@property (nonatomic, retain) IBOutlet UIWebView* webView;;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

@end
