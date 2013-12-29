//
//  NSTermsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 26/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSTermsViewController.h"

@interface NSTermsViewController ()

@end

@implementation NSTermsViewController
@synthesize scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"Terms";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:30.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    UITextView *mainContent = [[UITextView alloc]initWithFrame:CGRectMake(15,20, self.view.frame.size.width-30.f,0)];
    mainContent.text = @"This is terms and conditions to go";
    
    mainContent.textAlignment = NSTextAlignmentJustified;
    mainContent.textColor = [UIColor blackColor];
    mainContent.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    mainContent.scrollEnabled = NO;
    mainContent.editable = NO;
   /*
     mainContent.layer.borderWidth =1.0;
     mainContent.layer.cornerRadius =5.0;
     mainContent.layer.borderColor = [UIColor grayColor].CGColor;
    */
    [mainContent sizeToFit];
    [self.scrollView addSubview: mainContent];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainContent.frame.size.height+20.f+15.f)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
