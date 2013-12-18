//
//  NSFAQsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSFAQsViewController.h"
#import <QuartzCore/QuartzCore.h> 
@interface NSFAQsViewController ()

@end

@implementation NSFAQsViewController
@synthesize sendbutton,tvContent;
NSString *serverVersion;
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
    if ([self connectedToNetwork] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No internet, please try later?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    } else {
        
        [self getVersionWebService];
        modelVersionControl = [[VersionControl alloc] init];
        [modelVersionControl initDB];
        [modelVersionControl selectData];
        
        collection = [[NSMutableArray alloc] init];
        
        
        if ([modelVersionControl.vLink isEqualToString: @"0"])
        {
            // initialize welcometalk
            NSLog(@"NSFAQViewController: %s","initialize Link");
            [self loadDataFromWebService];
            int first = 0;
            for (FAQ * object in collection)
            {
                [object initDB];
                if(first == 0)
                {
                    [object clearData];
                    first = 1;
                }
                
                [object saveData:object.faqId question:object.question answer:object.answer];
            }
            [modelVersionControl initDB];
            [modelVersionControl updateData:@"versionfaq =:versionfaq" variable:@":versionfaq" data:serverVersion];
        }
        else
        {
            if ([modelVersionControl.vLink isEqualToString: serverVersion])
            {
                // sqlite db version is equal to mysql db version
                // get data from sqlite database
                NSLog(@"NSFAQViewController: %s","fetch from FAQ(sqlite)");
                FAQ *faq = [[FAQ alloc] init];
                [faq initDB];
                collection = [[faq selectData] mutableCopy];
            }
            else
            {
                // load data from mysql database
                // update data in sqlite database
                NSLog(@"NSFAQViewController: %s","fetch from FAQ(Web database)");
                [self loadDataFromWebService];
                
                int first = 0;
                for (FAQ * object in collection) {
                    [object initDB];
                    if(first == 0)
                    {
                        [object clearData];
                        first = 1;
                    }
                    [object saveData:object.faqId question:object.question answer:object.answer];
                }
                
                [modelVersionControl initDB];
                [modelVersionControl updateData:@"versionfaq =:versionfaq" variable:@":versionfaq" data:serverVersion];
            }
        }
    }

    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.translucent = NO;
   	self.sendbutton.tintColor = [UIColor blueColor];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"FAQs";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    tvContent.editable = NO;
    tvContent.text = [tvContent.text stringByAppendingString:@"\n"];
    for(FAQ * faq in collection) {
       tvContent.text = [tvContent.text stringByAppendingString:@"\n"];
       tvContent.text = [tvContent.text stringByAppendingString:@"Q: "];
       tvContent.text = [tvContent.text stringByAppendingString:faq.question];
       tvContent.text = [tvContent.text stringByAppendingString:@"\n"];
       tvContent.text = [tvContent.text stringByAppendingString:@"A: "];
       tvContent.text = [tvContent.text stringByAppendingString:faq.answer];
       tvContent.text = [tvContent.text stringByAppendingString:@"\n"];
   
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) getDataFromJson:(NSData *) data
{
    NSError *error;
    jsonFAQ = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void) prepareForWebService
{
    for (int i=0; i<jsonFAQ.count; i++)
    {
        NSDictionary *info = [jsonFAQ objectAtIndex:i];
        
        int Id = [[info objectForKey:@"id"] intValue];
        NSString *q = [info objectForKey:@"question"];
        NSString *a = [info objectForKey:@"answer"];
        
        FAQ *record = [[FAQ alloc]
                        initWithId:Id question:q answer:a];
        [collection addObject:record];
    }
    
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
    
    serverVersion = [info objectForKey:@"versionFAQ"];
}

-(IBAction)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        // device is configured to send mail
   
      MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
      [mailController setMailComposeDelegate:self];
      NSString *toEmail = FAQEmail;
      NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
      NSString *message = @"";//self.emailbody.text;
      [mailController setMessageBody:message isHTML:NO];
      [mailController setToRecipients:emailArray];
      [mailController setSubject:@"New@Shef:questions"];
      [self presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Do you want to login one email account now?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}
/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self emailbody] resignFirstResponder];
}
*/
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // after send email, clean the emailbody field.
   // self.emailbody.text = @"";
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
