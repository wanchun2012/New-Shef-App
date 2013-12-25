//
//  NSiPadTermsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 23/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"

@interface NSiPadTermsViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;


@end
