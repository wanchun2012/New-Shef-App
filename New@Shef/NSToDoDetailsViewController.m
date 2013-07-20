//
//  NSToDoDetailsViewController.m
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSToDoDetailsViewController.h"

@interface NSToDoDetailsViewController ()

@end

@implementation NSToDoDetailsViewController
@synthesize indexFirstTable,indexSecondTable, starterChecklist, btnDone, tvDescription, labelStatus, labelResponsiblePerson;
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
    NSString *pFile = [[NSBundle mainBundle] pathForResource:@"pNew_Starter_Checklist" ofType:@"plist"];
    starterChecklist = [[NSArray alloc] initWithContentsOfFile:pFile];
    
    tvDescription.textAlignment = NSTextAlignmentJustified;
    tvDescription.userInteractionEnabled = NO;
    tvDescription.text = [[[starterChecklist objectAtIndex:indexFirstTable] objectAtIndex:indexSecondTable+1] objectForKey:@"Details"];
    labelResponsiblePerson.text = [[[starterChecklist objectAtIndex:indexFirstTable] objectAtIndex:indexSecondTable+1] objectForKey:@"Responsible person"];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed
{
    
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *myDateString = [dateFormatter stringFromDate:myDate];
    labelStatus.text = myDateString;
}
@end
