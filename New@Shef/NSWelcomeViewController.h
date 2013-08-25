//
//  NSWelcomeViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Sqlite3Helper.h"
#import "WelcomeTalk.h"

#define GETUrl @"http://localhost/getWelcomeTalk.php"

@interface NSWelcomeViewController : UIViewController
{
    Sqlite3Helper *dbHelper;
    NSMutableArray *jsonWelcomeTalk;
    WelcomeTalk  *modelWelcomeTalk;
}

@property (weak, nonatomic) IBOutlet UITextView *tvWelcome;
@property (weak, nonatomic) IBOutlet UIImageView *ivWelcomeImage;

@end
