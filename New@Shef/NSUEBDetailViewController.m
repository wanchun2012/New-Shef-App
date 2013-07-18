//
//  NSUEBDetailViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 18/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSUEBDetailViewController.h"

@interface NSUEBDetailViewController ()

@end

@implementation NSUEBDetailViewController

@synthesize tvDetails, text;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
     ivWelcome = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Keith_Burnett.jpg"]]];
     
     CGPoint p = CGPointMake(160, 135);
     [ivWelcome setCenter: p];
     
     [self.view addSubview:self.ivWelcome];
     */
    
    [self.tvDetails setEditable:NO];
    self.tvDetails.textAlignment = NSTextAlignmentJustified;
    
    NSError *error;
    NSString* path = [[NSBundle mainBundle] pathForResource:text ofType:@"txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        
        NSLog(@"NSWelcomeViewController: loading WelcomeTalk.txt error occurs %@", error);
        
        return;
        
    }
    else
    {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        
        [self.tvDetails setFont:[UIFont systemFontOfSize:12]];
        [self.tvDetails setFrame:CGRectMake(screenSize.width/8,screenSize.height/8, screenSize.width/4*3, screenSize.height/8*5)];
        
        
        
        self.tvDetails.text = @"";
        // first, separate by new line
        NSString* someString;
        NSArray* allLinedStrings =
        [fileContents componentsSeparatedByCharactersInSet:
         [NSCharacterSet newlineCharacterSet]];
        for(int i=0;i<[allLinedStrings count];i++)
        {
            someString = [allLinedStrings objectAtIndex:i];
            someString = [someString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            self.tvDetails.text = [NSString stringWithFormat:@"%@%@", self.tvDetails.text, someString];
            
            
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
