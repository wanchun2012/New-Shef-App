//
//  NSWelcomeViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
//  reference: 1. load, save, image:
//             http://stackoverflow.com/questions/9941292/objective-c-failed-to-write-image-to-documents-directory
//             2. delete image:
//             http://stackoverflow.com/questions/9415221/delete-image-from-app-directory-in-iphone
#import <QuartzCore/QuartzCore.h>
#import "NSWelcomeViewController.h"

@interface NSWelcomeViewController ()
@end

@implementation NSWelcomeViewController
@synthesize scrollView;

NSString *serverVersion;
NSString *imagetype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void) getDataFromJson:(NSData *) data
{
    NSError *error;
    jsonWelcomeTalk = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    NSDictionary *info = [jsonWelcomeTalk objectAtIndex:0];
    modelWelcomeTalk.welcomeText = [info objectForKey:@"welcomeText"];
    NSString *temp =[info objectForKey:@"imageURL"];   
    [temp stringByReplacingOccurrencesOfString:@"/" withString:@""];
    modelWelcomeTalk.imageUrl = temp;
    imagetype = [info objectForKey:@"content_type"];
}

-(void) loadDataFromWebService
{
    NSURL *url = [NSURL URLWithString:GETUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getDataFromJson:data];
    [self prepareForWebService];
}

-(void) getVersionWebService
{
    NSURL *url = [NSURL URLWithString:GETVersion];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    jsonVersion = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary *info = [jsonVersion objectAtIndex:0];
    serverVersion = [info objectForKey:@"versionWelcomeTalk"];   
}

-(UIImage *) getImageFromURL:(NSString *)url
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension
      inDirectory:(NSString *)directoryPath
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
        NSLog(@"WelcomeViewController: Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
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
            NSLog(@"NSWelcomeViewController: %s%@","Delete failed from directory:", error);
        }
        else
        {
            NSLog(@"NSWelcomeViewController: %s%@","Image removed from directory:", fullPath1);
        }
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"])
    {
        NSString *fullPath2 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.jpg", fileName]];
        if(![fileManager removeItemAtPath: fullPath2 error:&error])
        {
            NSLog(@"NSWelcomeViewController: %s%@","Delete failed from directory: ", error);
        }
        else
        {
            NSLog(@"NSWelcomeViewController: %s%@","Image removed from directory: ",fullPath2);
        }
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result;
    NSLog(@"NSWelcomeViewController: %s","Image loading from directory");
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

- (void)viewDidLoad
{
 
    // prepare for welcome text
    [NSThread detachNewThreadSelector:@selector(backgroundThread) toTarget:self withObject:nil];
    [super viewDidLoad];
    
}

-(void)backgroundThread
{
    NSLog(@"NSWelcomeViewController: %s","backgroundThread starting...");
    [self performSelectorOnMainThread:@selector(mainThreadStarting) withObject:nil waitUntilDone:NO];
    UIImage *image;
    if ([self connectedToNetwork] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NOINTERNETALERTTITLE message:NOINTERNETMSG delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self getVersionWebService];
        modelVersionControl = [[VersionControl alloc] init];
        [modelVersionControl initDB];
        [modelVersionControl selectData];
        
        modelWelcomeTalk = [[WelcomeTalk alloc] init];
        [modelWelcomeTalk initDB];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        [self saveImage:image withFileName:@"welcometalk" ofType:imagetype inDirectory:[path objectAtIndex:0]];
        
        if ([modelVersionControl.vWelcomeTalk isEqualToString: @"0"])
        {
            // initialize welcometalk
            NSLog(@"NSWelcomeViewController: %s","initialize WELCOMETALK");
            [self loadDataFromWebService];
            [modelWelcomeTalk saveData:1 welcometext:modelWelcomeTalk.welcomeText conenttype: imagetype];
            
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versionwelcometalk =:versionwelcometalk" variable:@":versionwelcometalk" data:serverVersion];
            
            // save image to directory
            image = [self getImageFromURL:modelWelcomeTalk.imageUrl];
            [self saveImage:image withFileName:@"welcometalk" ofType:imagetype inDirectory:[path objectAtIndex:0]];
        }
        else
        {
            if ([modelVersionControl.vWelcomeTalk isEqualToString: serverVersion])
            {
                // sqlite db version is equal to mysql db version
                // get data from sqlite database
                NSLog(@"NSWelcomeViewController: %s","fetch from WELCOMETALK(sqlite)");
                [modelWelcomeTalk selectData];
                image = [self loadImage:@"welcometalk" ofType:modelWelcomeTalk.contenttype inDirectory:[path objectAtIndex:0]];
            }
            else
            {
                // delete image from directory
                [modelWelcomeTalk selectData];
                [self removeImage:@"welcometalk" ofType:modelWelcomeTalk.contenttype inDirectory:[path objectAtIndex:0]];
                // load data from mysql database
                // update data in sqlite database
                NSLog(@"NSWelcomeViewController: %s","fetch from WELCOMETALK(Web database)");
                
                [self loadDataFromWebService];
                [modelWelcomeTalk updateData:1 welcometext:modelWelcomeTalk.welcomeText conenttype:imagetype];
                
                [modelVersionControl initDB];
                [modelVersionControl updateData:@"versionwelcometalk =:versionwelcometalk" variable:@":versionwelcometalk"  data:serverVersion];
                image = [self getImageFromURL:modelWelcomeTalk.imageUrl];
                [self saveImage:image withFileName:@"welcometalk" ofType:imagetype inDirectory:[path objectAtIndex:0]];
            }
        }
        
    }
    [self performSelectorOnMainThread:@selector(mainThreadFinishing:) withObject:image waitUntilDone:NO];
    NSLog(@"NSWelcomeViewController: %s","backgroundThread finishing...");
}

-(void)mainThreadStarting
{
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [activityIndicator startAnimating];
}

-(void)mainThreadFinishing:(UIImage *)image
{
    if ([self connectedToNetwork]==YES)
    {
        UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width, 20)];
        labelTitle.text = @"Welcome to the University of Sheffield";
        labelTitle.textAlignment = NSTextAlignmentCenter;
       
        labelTitle.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        [self.scrollView addSubview:labelTitle];
        
        UITextView * mainContent = [[UITextView alloc]initWithFrame:CGRectMake(15,45, self.view.frame.size.width-30.f-80.f, 0)];
        mainContent.text = modelWelcomeTalk.welcomeText;
        mainContent.textAlignment = NSTextAlignmentJustified;
        mainContent.textColor = [UIColor blackColor];
        mainContent.font = [UIFont fontWithName:@"AppleGothic" size:15.0f];
        [mainContent sizeToFit];
        mainContent.scrollEnabled = NO;
        mainContent.editable = NO;
        [self.scrollView addSubview: mainContent];
        UIImageView *ivWelcome = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90.f, 50.f, 75.f, 100.f)];
        [ivWelcome setImage:image];
        [self.scrollView addSubview:ivWelcome];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self  action:@selector(enterPage:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Enter" forState:UIControlStateNormal];
        button.frame = CGRectMake(self.view.frame.size.width-80.f, mainContent.frame.size.height+15.f, 50.0, 30.0);
        [self.scrollView addSubview:button];
        
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, mainContent.frame.size.height+45.f+15.f)];
 
        activityIndicator.hidden = YES;
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    
    }
}

-(void)enterPage:(id)sender
{
   
    [self performSegueWithIdentifier:@"Associate" sender:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
  