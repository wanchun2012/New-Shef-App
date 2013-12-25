//
//  NSAppDelegate.m
//  New@Shef
//
//  Created by Wanchun Zhang on 10/07/2013.
//  Copyright (c) 2013 Wanchun Zhang. All rights reserved.
//

#import "NSAppDelegate.h"
#import "NSiPadRootViewController.h"
#import "NSiPadWelcomeViewController.h"

@implementation NSAppDelegate
@synthesize   splitViewController, detailViewController, rootViewController,window;
@synthesize rootPopoverButtonItem;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // googlemap
    [GMSServices provideAPIKey:@"AIzaSyAaVbbyUprkuokNz5_VrfTYCneh6DaFHZ8"];
    
    // icloud
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document...
    } else {
        NSLog(@"No iCloud access");
    }
    
    BOOL iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    if (iPad)
    {
        NSLog(@"Now, time to do some crazy stuff on iPad, lets wash bathroom T.T");
        // Override point for customization after app launch.
        self.splitViewController =[[UISplitViewController alloc]init];
        self.rootViewController=[[NSiPadRootViewController alloc]init];
        self.detailViewController=[[NSiPadWelcomeViewController alloc]init];
        
        UINavigationController *rootNav=[[UINavigationController alloc]initWithRootViewController:rootViewController];
        UINavigationController *detailNav=[[UINavigationController alloc]initWithRootViewController:detailViewController];
        
        
        self.splitViewController.viewControllers=[NSArray arrayWithObjects:rootNav,detailNav,nil];
        self.splitViewController.delegate=(id)self.detailViewController;
        
        // Add the split view controller's view to the window and display.
        [window addSubview:self.splitViewController.view];
        [window makeKeyAndVisible];
        
        self.splitViewController.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        CGRect frame = CGRectMake(0, 0, screenWidth,screenHeight);
        self.splitViewController.view.frame = frame;
        NSLog(@"Lets wash bathroom again on Monday");
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
