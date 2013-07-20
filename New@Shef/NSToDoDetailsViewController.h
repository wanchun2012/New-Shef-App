//
//  NSToDoDetailsViewController.h
//  New@Shef
//
//  Created by Wanchun Zhang on 20/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSToDoDetailsViewController : UIViewController
@property (nonatomic,assign) int indexFirstTable;
@property (nonatomic, assign) int indexSecondTable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (weak, nonatomic) IBOutlet UITextView *tvDescription;


@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelResponsiblePerson;


@property (nonatomic, strong) NSArray *starterChecklist;

-(IBAction)donePressed;
@end
