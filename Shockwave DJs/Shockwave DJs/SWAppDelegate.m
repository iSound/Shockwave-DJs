//
//  SWAppDelegate.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 2/28/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWAppDelegate.h"

@implementation SWAppDelegate

@synthesize audioPlayer = _audioPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (![[[UIViewController alloc] init] respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
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
        
        SWHomeViewController *home = [[SWHomeViewController alloc] init];
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
        
        SWChatViewController *chat = [[SWChatViewController alloc] init];
        UINavigationController *chatNavController = [[UINavigationController alloc] initWithRootViewController:chat];
        slidingController.underRightViewController = chatNavController;
        [slidingController setAnchorLeftRevealAmount:280.0f];
        
        self.window.rootViewController = slidingController;
    }
    
    // Audio Player notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playRecordedMix:) name:@"playRecordedMix" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseRecordedMix:) name:@"pauseRecordedMix" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeRecordedMix:) name:@"resumeRecordedMix" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playLiveMix:) name:@"playLiveMix" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMix:) name:@"stopMix" object:nil];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    UIAlertView *pushAlert = [[UIAlertView alloc] initWithTitle:@"Push Notification Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [pushAlert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)playRecordedMix:(NSNotification *)notification {
    self.audioPlayer = [[SWAudioPlayer alloc] initWithMix:(PFObject *)[notification object]];
    [self.audioPlayer prepareToPlay:(PFObject *)[notification object]];
    [self.audioPlayer play:(PFObject *)[notification object]];
}

- (void)pauseRecordedMix:(NSNotification *)notification {
    [self.audioPlayer pause];
}

- (void)resumeRecordedMix:(NSNotification *)notification {
    [self.audioPlayer resume];
}

- (void)playLiveMix:(NSNotification *)notification {
    self.audioPlayer = [[SWAudioPlayer alloc] initWithLiveMix:(PFObject *)[notification object]];
    [self.audioPlayer prepareToPlay:(PFObject *)[notification object]];
    [self.audioPlayer play:(PFObject *)[notification object]];
}

- (void)stopMix:(NSNotification *)notification {
    // Update plays
    [self.audioPlayer stop];
}

@end