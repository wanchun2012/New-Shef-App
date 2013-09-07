//
//  NSFAQsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
//#define FAQEmail @"hr-enq@sheffield.ac.uk"
#define FAQEmail @"wanchun.zhang2012@gmail.com"

@interface NSFAQsViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *emailbody;
@property (weak, nonatomic) IBOutlet UIButton *sendbutton;
- (IBAction)sendEmail;
@end
