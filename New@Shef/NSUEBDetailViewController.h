//
//  NSUEBDetailViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSUEBDetailViewController : UIViewController
@property (strong) NSString *txtName;
@property (strong) NSString *txtRole;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelRole;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;

@property (weak, nonatomic) IBOutlet UITextView *tvDetails;
@end

