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

#import "NSWelcomeViewController.h"

@interface NSWelcomeViewController ()
@end

@implementation NSWelcomeViewController
@synthesize tvWelcome, ivWelcomeImage, btnenter,loadingIndicator;

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
    ivWelcomeImage.frame = CGRectMake(ivWelcomeImage.frame.origin.x,ivWelcomeImage.frame.origin.y,75,100);
    // prepare for welcome text
    [self.tvWelcome setEditable:NO];
    self.tvWelcome.textAlignment = NSTextAlignmentJustified;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.tvWelcome setFont:[UIFont systemFontOfSize:12]];
    [self.tvWelcome setFrame:CGRectMake(screenSize.width/8,screenSize.height/8,
                                        screenSize.width/4*3, screenSize.height/8*5)];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        NSLog(@"NSWelcomeViewController: %s","There is no network...");
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
    [self.loadingIndicator startAnimating];
}

-(void)mainThreadFinishing:(UIImage *)image
{
    if ([self connectedToNetwork])
    {
        // prepare for welcome image
        [ivWelcomeImage setImage:image];
        
        // prepare for welcome text
        self.tvWelcome.text = modelWelcomeTalk.welcomeText;
    }
   
    self.loadingIndicator.hidden = YES;
    [self.loadingIndicator stopAnimating];
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
  