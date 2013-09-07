//
//  MyDocument.h
//  New@Shef
//
//  Created by Wanchun Zhang on 01/09/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//
//  Reference: 1. icloud and document
//             http://www.techotopia.com/index.php/Using_iCloud_Storage_in_an_iOS_5_iPhone_Application

#import <UIKit/UIKit.h>

@interface MyDocument : UIDocument
{
    NSString *userText;
}
@property (strong, nonatomic) NSString *userText;
@end