//
//  NSContactDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 17/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSContactDetailViewController : UIViewController
@property (strong) NSString *text;
@property (strong) NSString *emailtxt;
@property (strong) NSString *phonetxt;


@property (weak) IBOutlet UILabel *viewLabel;
@property (nonatomic, retain) IBOutlet UITextView *details;
@end
