//
//  NSiPadWelcomeViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import "sqlite3.h"
#import "WelcomeTalk.h"
#import "VersionControl.h"

#define GETUrl @"http://54.213.22.84/getWelcomeTalk.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"


@interface NSiPadWelcomeViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    NSMutableArray *jsonWelcomeTalk;
    NSMutableArray *jsonVersion;
    WelcomeTalk *modelWelcomeTalk;
    VersionControl *modelVersionControl;
 
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UITextView *tvWelcome;
@property (weak, nonatomic) IBOutlet UIImageView *ivWelcomeImage;
 

@end
