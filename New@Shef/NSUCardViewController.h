//
//  NSUCardViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NSUCardViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationBarDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *picker1;
@property (strong, nonatomic) UIImagePickerController *picker2;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction) TakePhoto;
- (IBAction) ChoosePhoto;
- (IBAction) SendEmail;
@end
