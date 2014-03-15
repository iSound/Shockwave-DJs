//
//  SWTopViewController.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/15/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWTopViewController.h"

#import "SWMenuViewController.h"
#import "SWChatViewController.h"

@interface SWTopViewController ()

@end

@implementation SWTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        // Gesture
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
        
        // Shadow
        self.navigationController.view.layer.shadowOpacity = 0.75f;
        self.navigationController.view.layer.shadowRadius = 10.0f;
        self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        
        if ([[self.slidingViewController underLeftViewController] isKindOfClass:[SWMenuViewController class]]) {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu)];
            } else {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showLeftMenu)];
            }
        }
        
        if ([[self.slidingViewController underRightViewController] isKindOfClass:[UINavigationController class]]) {
            if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStylePlain target:self action:@selector(showRightChat)];
            } else {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Chat" style:UIBarButtonItemStyleBordered target:self action:@selector(showRightChat)];
            }
        }
    }
}

- (void)showLeftMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)showRightChat {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

@end