//
//  UICustomizedButton.h
//  New@Shef
//
//  Created by Wanchun Zhang on 15/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface UICustomizedButton : UIButton
{
    NSString *phone;
    NSString *email;
}

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *email;

 
@end
