//
//  NSUEBDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSUEBDetailViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
  
}

@property (strong) NSString *txtName;
@property (strong) NSString *txtUrl;
@property (strong) NSString *txtRole;
@property (strong) NSString *txtDescription;
@property (strong) NSString *txtStatus;
@property (strong) NSString *txtType;
@property (strong) NSString *uebId;
 

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end



