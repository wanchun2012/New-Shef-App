//
//  NSWelcomeViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSWelcomeViewController.h"
 
@interface NSWelcomeViewController ()

@end

@implementation NSWelcomeViewController
@synthesize tvWelcome, ivWelcomeImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) getData:(NSData *) data
{
    NSError *error;
    
    jsonWelcomeTalk = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void) prepareForModel
{
    NSDictionary *info = [jsonWelcomeTalk objectAtIndex:0];
    
    modelWelcomeTalk.welcomeText = [info objectForKey:@"welcomeText"];
    NSString *temp =[info objectForKey:@"imageURL"];    
    [temp stringByReplacingOccurrencesOfString:@"/" withString:@""];
    modelWelcomeTalk.imageUrl = temp;
}

-(void) start {
    NSURL *url = [NSURL URLWithString:GETUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self getData:data];
    [self prepareForModel];
    
}
 
- (void)viewDidLoad
{
    modelWelcomeTalk = [[WelcomeTalk alloc] init];
    dbHelper = [[Sqlite3Helper alloc] init];
    [dbHelper openDB];
    [dbHelper saveData];
    [self start];
    [super viewDidLoad];
           
    NSURL *url = [NSURL URLWithString:modelWelcomeTalk.imageUrl];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
        
    UIImage * myImage = image;
    ivWelcomeImage.frame = CGRectMake(ivWelcomeImage.frame.origin.x,ivWelcomeImage.frame.origin.y,width,height);
    [ivWelcomeImage setImage:myImage];
               
    [self.tvWelcome setEditable:NO];
    self.tvWelcome.textAlignment = NSTextAlignmentJustified;
      
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
            
    [self.tvWelcome setFont:[UIFont systemFontOfSize:12]];
    [self.tvWelcome setFrame:CGRectMake(screenSize.width/8,screenSize.height/8, screenSize.width/4*3, screenSize.height/8*5)];
            
    self.tvWelcome.text = @"";
    // first, separate by new line
    NSString* someString;
    NSArray* allLinedStrings =
    [modelWelcomeTalk.welcomeText componentsSeparatedByCharactersInSet:
    [NSCharacterSet newlineCharacterSet]];
    for(int i=0;i<[allLinedStrings count];i++)
    {
        someString = [allLinedStrings objectAtIndex:i];
        someString = [someString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        self.tvWelcome.text = [NSString stringWithFormat:@"%@%@", self.tvWelcome.text, someString];
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
