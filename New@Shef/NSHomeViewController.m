//
//  NSHomeViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 21/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import "NSHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
 
@interface NSHomeViewController ()

@end

@implementation NSHomeViewController
@synthesize btnChecklist,btnContacts,btnFAQ,btnLinks,btnMap,btnNews,btnSocial,btnUCard,btnUEB,
    labelChecklist,labelContacts,labelFAQ,labelLink,labelMap,labelNews,labelSocial,labelUCard,labelUEB,footer,btnTerms;

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
    UIColor *blue = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = blue;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"New@Shef";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:30.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    self.labelUEB.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelUCard.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelSocial.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelNews.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelMap.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelLink.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelFAQ.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelContacts.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.labelChecklist.font = [UIFont fontWithName:@"AppleGothic" size:12.0f];
    self.footer.font = [UIFont fontWithName:@"AppleGothic" size:10.0f];
    self.btnTerms.titleLabel.font = [UIFont fontWithName:@"AppleGothic" size:10.0f];
    
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
    
    [super viewDidLoad];
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
     
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(-1); // no
    }

    
}
 

- (BOOL) connectedToNetwork
{
    BOOL result = NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    result = !(networkStatus==NotReachable);
    if (result == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}

@end
