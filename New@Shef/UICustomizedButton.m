//
//  UICustomizedButton.m
//  New@Shef
//
//  Created by Wanchun Zhang on 15/12/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "UICustomizedButton.h"

@implementation UICustomizedButton
@synthesize phone,email;
- (id)initWithFrame:(CGRect)frame phone:p email:e
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.phone = p;
        self.email = e;
    }
    return self;
}
@end
