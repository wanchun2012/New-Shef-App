//
//  NSAppDelegate.h
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class NSiPadRootViewController;
@class NSiPadWelcomeViewController;

@interface NSAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    
    UISplitViewController *splitViewController;
    
    NSiPadRootViewController *rootViewController;
    NSiPadWelcomeViewController *detailViewController;
    
  
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain)  UISplitViewController *splitViewController;
@property (nonatomic, retain)  NSiPadRootViewController *rootViewController;
@property (nonatomic, retain)  NSiPadWelcomeViewController *detailViewController;
@property (unsafe_unretained) UIBarButtonItem *rootPopoverButtonItem;

@end