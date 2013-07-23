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
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.text = @"FAQs";
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
	// Do any additional setup after loading the view.
    [[self.emailbody layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.emailbody layer] setBorderWidth:2.3];
    [[self.emailbody layer] setCornerRadius:15];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendEmail
{
    MFMailComposeViewController *mailController = [[ MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    NSString *toEmail = @"hr-enq@sheffield.ac.uk";
    NSArray *emailArray = [[NSArray alloc]initWithObjects:toEmail, nil];
    NSString *message = self.emailbody.text;
    [mailController setMessageBody:message isHTML:NO];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@"New@Shef:questions"];
    [self presentViewController:mailController animated:YES completion:nil];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self emailbody] resignFirstResponder];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // after send email, clean the emailbody field.
    self.emailbody.text = @"";
}

@end
