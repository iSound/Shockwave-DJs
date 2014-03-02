//
//  PSBNAppDelegate.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 2/28/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSBNAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end
