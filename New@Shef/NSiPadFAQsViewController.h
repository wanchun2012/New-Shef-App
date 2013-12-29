//
//  NSiPadFAQsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 22/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "sqlite3.h"
#import "FAQ.h"
#import "VersionControl.h"
//#define FAQEmail @"hr-enq@sheffield.ac.uk"
#define FAQEmail @"wanchun.zhang2012@gmail.com"
#define GETFAQ @"http://54.213.22.84/getFAQ.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
#define NOEMAILTITLE @"No email account"
#define NOEMAILMSG @"Do you want exit app and login one email account now?"
#define FAQSUBJECT @"New@Shef:questions"
@interface NSiPadFAQsViewController : UIViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    
    UIPopoverController *popoverController;
    
    NSMutableArray *jsonFAQ;
    NSMutableArray *jsonVersion;
    NSMutableArray *collection;
    VersionControl *modelVersionControl;
    
    UIActivityIndicatorView *activityIndicator;

    
}

@property (nonatomic, assign) NSAppDelegate *appDelegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
 
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end
