//
//  NSHomeViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 21/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSHomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NSHomeViewController ()

@end

@implementation NSHomeViewController
@synthesize btnChecklist,btnContacts,btnFAQ,btnLinks,btnMap,btnNews,btnSocial,btnUCard,btnUEB;
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
    self.navigationController.navigationBar.translucent = NO;
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"New@Shef";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    //UIImage *img = [UIImage imageNamed:@"background.jpg"];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    self.btnChecklist.layer.cornerRadius = 10;
    self.btnChecklist.clipsToBounds = YES;
    
    self.btnContacts.layer.cornerRadius = 10;
    self.btnContacts.clipsToBounds = YES;
    
    self.btnFAQ.layer.cornerRadius = 10;
    self.btnFAQ.clipsToBounds = YES;
    
    self.btnLinks.layer.cornerRadius = 10;
    self.btnLinks.clipsToBounds = YES;
    
    self.btnMap.layer.cornerRadius = 10;
    self.btnMap.clipsToBounds = YES;
    
    self.btnNews.layer.cornerRadius = 10;
    self.btnNews.clipsToBounds = YES;
    
    self.btnSocial.layer.cornerRadius = 10;
    self.btnSocial.clipsToBounds = YES;
    
    self.btnUCard.layer.cornerRadius = 10;
    self.btnUCard.clipsToBounds = YES;
    
    self.btnUEB.layer.cornerRadius = 10;
    self.btnUEB.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueNews"]
        ||[[segue identifier] isEqualToString:@"segueMap"]
        ||[[segue identifier] isEqualToString:@"segueSocial"]
    //  ||[[segue identifier] isEqualToString:@"segueUEB"]
    //  ||[[segue identifier] isEqualToString:@"segueChecklist"]
        ||[[segue identifier] isEqualToString:@"segueUCard"]
   //   ||[[segue identifier] isEqualToString:@"segueContacts"]
   //   ||[[segue identifier] isEqualToString:@"segueLinks"]
        ||[[segue identifier] isEqualToString:@"segueFAQ"]) {
        
        if ([self connectedToNetwork] == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];

        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //  exit(-1); // no
    }
    if(buttonIndex == 1)
    {
        exit(-1); // yes
    }
    
}

- (BOOL) connectedToNetwork
{
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    return (connect!=NULL)?YES:NO;
}

@end
