//
//  SWAppDelegate.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 2/28/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWAppDelegate.h"

@implementation SWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([self.window respondsToSelector:@selector(setTintColor:)]) {
        // [self.window setTintColor:[UIColor blueColor]];
    }
    // Override point for customization after application launch.
    
    // Parse stuff
    [Parse setApplicationId:@"lnaM8pzMqf69U898rdhO9k5As1YJbM9GMte19R3b" clientKey:@"bmCrCgflMgH0xBXOr6ojpuCP0snRNucu1cykyiJj"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Register for push notifications
    // [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    // Reset app icon badge
    if (application.applicationIconBadgeNumber > 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = self;
        
        SWMenuViewController *menu = [[SWMenuViewController alloc] init];
        UINavigationController *menuNavController = [[UINavigationController alloc] initWithRootViewController:menu];
        
        SWHomeViewController_iPad *home = [[SWHomeViewController_iPad alloc] init];
        UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:home];
        
        self.splitViewController.viewControllers = @[menuNavController, homeNavController];
        
        self.window.rootViewController = self.splitViewController;
    } else {
        ECSlidingViewController *slidingController = [[ECSlidingViewController alloc] init];
        
        SWMenuViewController *menu = [[SWMenuViewController alloc] init];
        slidingController.underLeftViewController = menu;
        
        SWHomeViewController *home = [[SWHomeViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:home];
        slidingController.topViewController = navController;
        
        [slidingController setAnchorRightRevealAmount:200.0f];
        
        self.window.rootViewController = slidingController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    // PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    // [currentInstallation setDeviceTokenFromData:deviceToken];
    // [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"Push Notification Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [pushAlert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // [PFPush handlePush:userInfo];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
