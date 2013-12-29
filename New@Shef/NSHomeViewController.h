//
//  NSHomeViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 21/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOINTERNETMSG @"There is no internet, app exit, please wait and try later."
#define NOINTERNETALERTTITLE @"No internet"
@interface NSHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelNews;
@property (weak, nonatomic) IBOutlet UILabel *labelMap;
@property (weak, nonatomic) IBOutlet UILabel *labelSocial;
@property (weak, nonatomic) IBOutlet UILabel *labelUEB;
@property (weak, nonatomic) IBOutlet UILabel *labelChecklist;
@property (weak, nonatomic) IBOutlet UILabel *labelUCard;
@property (weak, nonatomic) IBOutlet UILabel *labelContacts;
@property (weak, nonatomic) IBOutlet UILabel *labelFAQ;
@property (weak, nonatomic) IBOutlet UILabel *labelLink;

@property (weak, nonatomic) IBOutlet UIButton *btnNews;
@property (weak, nonatomic) IBOutlet UIButton *btnMap;
@property (weak, nonatomic) IBOutlet UIButton *btnSocial;
@property (weak, nonatomic) IBOutlet UIButton *btnUEB;
@property (weak, nonatomic) IBOutlet UIButton *btnChecklist;
@property (weak, nonatomic) IBOutlet UIButton *btnUCard;
@property (weak, nonatomic) IBOutlet UIButton *btnContacts;
@property (weak, nonatomic) IBOutlet UIButton *btnFAQ;
@property (weak, nonatomic) IBOutlet UIButton *btnLinks;
@property (weak, nonatomic) IBOutlet UILabel *footer;
@property (weak, nonatomic) IBOutlet UIButton *btnTerms;

@end
