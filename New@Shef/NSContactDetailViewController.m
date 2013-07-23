//
//  NSContactDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 17/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSContactDetailViewController.h"

@interface NSContactDetailViewController ()

@end

@implementation NSContactDetailViewController
@synthesize text, viewLabel, emailtxt, phonetxt, emailLabel, phoneLabel;
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
    viewLabel.text = text;
    emailLabel.numberOfLines = 0;
    phoneLabel.numberOfLines = 0;
    emailLabel.text = emailtxt;
    phoneLabel.text = phonetxt;//[NSString stringWithFormat:@"Phone number: \n  %@",phonetxt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
