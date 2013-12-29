//
//  NSiPadRootViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//  Reference:
//  http://kshitizghimire.com.np/uisplitviewcontroller-multipledetailviews-with-navigation-controller/

#import <UIKit/UIKit.h>
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@class NSiPadWelcomeViewController;
@class NSiPadNewsViewController;
@class NSiPadFacebookViewController;
@class NSiPadMapViewController;
@class NSiPadUCardViewController;
@class NSiPadUEBViewController;
@class NSiPadChecklistViewController;
@class NSiPadContactsViewController;
@class NSiPadFAQsViewController;
@class NSiPadLinkViewController;
@class NSiPadTermsViewController;
@class NSAppDelegate;

@interface NSiPadRootViewController : UITableViewController
{
    NSiPadWelcomeViewController *welcomeVC;
    NSiPadNewsViewController *newsVC;
    NSiPadMapViewController *mapVC;
    NSiPadFacebookViewController *facebookVC;
    NSiPadUEBViewController *uebVC;
    NSiPadChecklistViewController *checklistVC;
    NSiPadUCardViewController *ucardVC;
    NSiPadContactsViewController *contactsVC;
    NSiPadFAQsViewController *faqVC;
    NSiPadLinkViewController *linkVC;
    NSiPadTermsViewController *termsVC;
 
}

@property (nonatomic, retain) NSiPadWelcomeViewController *welcomeVC;
@property (nonatomic, retain) NSiPadNewsViewController *newsVC;
@property (nonatomic, retain) NSiPadMapViewController *mapVC;
@property (nonatomic, retain) NSiPadFacebookViewController *facebookVC;
@property (nonatomic, retain) NSiPadChecklistViewController *checklistVC;
@property (nonatomic, retain) NSiPadUCardViewController *ucardVC;
@property (nonatomic, retain) NSiPadUEBViewController *uebVC;
@property (nonatomic, retain) NSiPadContactsViewController *contactsVC;
@property (nonatomic, retain) NSiPadFAQsViewController *faqVC;
@property (nonatomic, retain) NSiPadLinkViewController *linkVC;
@property (nonatomic, retain) NSiPadTermsViewController *termsVC;
@property (nonatomic, assign) NSAppDelegate *appDelegate;

@end
