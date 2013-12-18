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
@synthesize text, viewLabel, emailtxt, phonetxt, details;
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
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
	// Do any additional setup after loading the view.
    self.viewLabel.text = text;
    self.details.text = [NSString stringWithFormat: @"Email: %@\n\nPhone: %@", emailtxt, phonetxt];
    self.details.text = [self.details.text stringByReplacingOccurrencesOfString :@"+" withString:@" "];
    self.details.editable = NO;
    self.details.dataDetectorTypes = UIDataDetectorTypeAll;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
