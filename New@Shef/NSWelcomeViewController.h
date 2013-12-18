//
//  NSWelcomeViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "WelcomeTalk.h"
#import "VersionControl.h"

#define GETUrl @"http://54.213.22.84/getWelcomeTalk.php"
#define GETVersion @"http://54.213.22.84/getVersionControl.php"

@interface NSWelcomeViewController : UIViewController
{
    NSMutableArray *jsonWelcomeTalk;
    NSMutableArray *jsonVersion;
    WelcomeTalk *modelWelcomeTalk;
    VersionControl *modelVersionControl;
}

@property (weak, nonatomic) IBOutlet UITextView *tvWelcome;
@property (weak, nonatomic) IBOutlet UIImageView *ivWelcomeImage;
@property (weak, nonatomic) IBOutlet UIButton *btnenter;

@end
