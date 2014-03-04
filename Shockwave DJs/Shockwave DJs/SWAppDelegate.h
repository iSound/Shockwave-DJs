//
//  SWAppDelegate.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 2/28/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "ECSlidingViewController.h"

#import "SWHomeViewController.h"
#import "SWHomeViewController_iPad.h"
#import "SWMenuViewController.h"

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end
