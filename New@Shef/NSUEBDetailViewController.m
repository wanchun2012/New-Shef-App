//
//  NSUEBDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
//  reference: 1. load, save, image:
//             http://stackoverflow.com/questions/9941292/objective-c-failed-to-write-image-to-documents-directory
//             2. delete image:
//             http://stackoverflow.com/questions/9415221/delete-image-from-app-directory-in-iphone

#import <QuartzCore/QuartzCore.h>
#import "NSUEBDetailViewController.h"

@interface NSUEBDetailViewController ()

@end

@implementation NSUEBDetailViewController

@synthesize  txtName, txtRole, txtDescription, txtStatus, uebId, txtUrl, txtType, scrollView ;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIColor *nevBarColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:0.5f];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = nevBarColor;
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = txtRole;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    titleView.textColor = [UIColor whiteColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    if ([self connectedToNetwork] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    }
    [super viewDidLoad];
}

-(void)backgroundThread
{
    NSLog(@"NSUEBDetailViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    UIImage * myImage;
 
    // prepare for image
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *name = [NSString stringWithFormat:@"ueb_%@", uebId];
    NSString *dirpath = [path objectAtIndex:0];
    
    if([txtStatus isEqualToString:@"download"])
    {
        myImage = [self getImageFromURL:txtUrl];
        [self saveImage:myImage withFileName:name ofType:txtType inDirectory:dirpath];
        NSLog(@"download from webservice, due to web server updating....");
        
    }
    else
    {
        myImage = [self loadImage:name ofType:txtType inDirectory:dirpath];
        
        if(myImage==NULL)
        {
            myImage = [self getImageFromURL:txtUrl];
            [self saveImage:myImage withFileName:name ofType:txtType inDirectory:dirpath];
            NSLog(@"download from webservice, first download");
        }
    }
 
    [self performSelectorOnMainThread:@selector(mainThreadFinishing:) withObject:myImage waitUntilDone:NO];
    NSLog(@"NSUEBDetailViewController: %s","backgroundThread finishing...");
}

-(void)mainThreadStarting
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [activityIndicator startAnimating];
}

-(void)mainThreadFinishing:(UIImage *) myImage
{
    // prepare for description

    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(15,20,self.view.frame.size.width, 20)];
    labelTitle.text = txtName;
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.numberOfLines = 0;
    labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labelTitle.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    [self.scrollView addSubview:labelTitle];
     /*
    NSString *text = txtDescription;
   
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:text
                                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleGothic" size:15.0f]}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width-30.f, 9999}
                                               options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    */
    UITextView * mainContent = [[UITextView alloc]initWithFrame:CGRectMake(15,120, self.view.frame.size.width-30.f, 0)];
    mainContent.text = txtDescription;
    mainContent.textAlignment = NSTextAlignmentJustified;
    mainContent.textColor = [UIColor blackColor];
    mainContent.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
    mainContent.scrollEnabled = NO;
    mainContent.editable = NO;
    mainContent.layer.borderWidth =1.0;
    mainContent.layer.cornerRadius =5.0;
    mainContent.layer.borderColor = [UIColor grayColor].CGColor;
    [mainContent sizeToFit];
    [self.scrollView addSubview: mainContent];
    
    UIImageView *ivUEB= [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 75.f, 20.f, 60.f, 80.f)];
    [ivUEB setImage:myImage];
    [self.scrollView addSubview:ivUEB];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainContent.frame.size.height+15.f+120.f)];
    
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *) getImageFromURL:(NSString *)url
{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName
           ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"image/png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    }
    else if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }
    else
    {
        NSLog(@"NSUEBDetailViewController: Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (void)removeImage:(NSString*)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    if ([[extension lowercaseString] isEqualToString:@"image/png"])
    {
        NSString *fullPath1 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.png", fileName]];
        
        if(![fileManager removeItemAtPath: fullPath1 error:&error])
        {
            NSLog(@"NSUEBDetailViewController: Delete failed:%@", error);
        }
        else
        {
            NSLog(@"NSUEBDetailViewController: Image removed: %@", fullPath1);
        }
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        NSString *fullPath2 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.jpg", fileName]];
        if(![fileManager removeItemAtPath: fullPath2 error:&error])
        {
            NSLog(@"NSUEBDetailViewController: Delete failed:%@", error);
        }
        else
        {
            NSLog(@"NSUEBDetailViewController: Image removed: %@", fullPath2);
        }
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result;
    NSLog(@"NSUEBDetailViewController: image loading........");
    if ([[extension lowercaseString] isEqualToString:@"image/png"])
    {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"png"]];
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"]|| [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"jpg"]];
    }
    return result;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
         exit(-1);
    }
 
}

- (BOOL) connectedToNetwork
{
    NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://google.co.uk"] encoding:NSUTF8StringEncoding error:nil];
    return (connect!=NULL)?YES:NO;
}

@end
