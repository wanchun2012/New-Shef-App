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

#import "NSUEBDetailViewController.h"

@interface NSUEBDetailViewController ()

@end

@implementation NSUEBDetailViewController

@synthesize labelName, labelRole,tvDetails, txtName, txtRole, txtDescription, ivPhoto, txtStatus, uebId, txtUrl, txtType ;
 
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
    //prepare for label
    [super viewDidLoad];
    labelName.numberOfLines = 0;
    labelName.lineBreakMode = UILineBreakModeWordWrap;
    labelRole.numberOfLines = 0;
    labelRole.lineBreakMode = UILineBreakModeWordWrap;
    labelName.text = [txtName stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    labelRole.text = [txtRole stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [labelRole setFont: [UIFont systemFontOfSize:14]];
    
    
    // prepare for image
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *name = [NSString stringWithFormat:@"ueb_%@", uebId];
    NSString *dirpath = [path objectAtIndex:0];
    UIImage * myImage;
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
    
    [ivPhoto setImage:myImage];
    
    // prepare for description
    [self.tvDetails setEditable:NO];
    self.tvDetails.textAlignment = NSTextAlignmentJustified;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.tvDetails setFont:[UIFont systemFontOfSize:14]];
    [self.tvDetails setFrame:CGRectMake(screenSize.width/8,
                                        screenSize.height/8,
                                        screenSize.width/4*3,
                                        screenSize.height/8*5)];
        
    self.tvDetails.text = @"";
    // first, separate by new line
    NSString* someString;
    NSArray* allLinedStrings =
    [txtDescription componentsSeparatedByCharactersInSet:
    [NSCharacterSet newlineCharacterSet]];
    for(int i=0;i<[allLinedStrings count];i++)
    {
        someString = [allLinedStrings objectAtIndex:i];
        someString = [someString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        self.tvDetails.text = [NSString stringWithFormat:@"%@%@", self.tvDetails.text, someString];
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *) getImageFromURL:(NSString *)url {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"image/png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (void)removeImage:(NSString*)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    if ([[extension lowercaseString] isEqualToString:@"image/png"]) {
        NSString *fullPath1 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.png", fileName]];
        
        if(![fileManager removeItemAtPath: fullPath1 error:&error]) {
            NSLog(@"Delete failed:%@", error);
        } else {
            NSLog(@"image removed: %@", fullPath1);
        }
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"] || [[extension lowercaseString] isEqualToString:@"image/jpeg"]) {
        NSString *fullPath2 = [directoryPath stringByAppendingPathComponent:
                               [NSString stringWithFormat:@"%@.jpg", fileName]];
        if(![fileManager removeItemAtPath: fullPath2 error:&error]) {
            NSLog(@"Delete failed:%@", error);
        } else {
            NSLog(@"image removed: %@", fullPath2);
        }
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result;
    NSLog(@"image loading........");
    if ([[extension lowercaseString] isEqualToString:@"image/png"]) {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"png"]];
    }
    if ([[extension lowercaseString] isEqualToString:@"image/jpg"]|| [[extension lowercaseString] isEqualToString:@"image/jpeg"]) {
        result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, @"jpg"]];
    }
    return result;
}

 
@end
