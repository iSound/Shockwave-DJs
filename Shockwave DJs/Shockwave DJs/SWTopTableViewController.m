//
//  SWTopTableViewController.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWTopTableViewController.h"

#import "SWMenuViewController.h"
#import "SWChatViewController.h"

@interface SWTopTableViewController ()

@end

@implementation SWTopTableViewController

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
    } else {
        masterIsVisible = NO;
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.navigationController.view addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.navigationController.view addGestureRecognizer:swipeRight];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self.view addGestureRecognizer:tap];
        
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            [self addMasterButton];
        }
    }
}

- (void)showLeftMenu {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)showRightChat {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (void)handleSwipeLeft {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self hideMasterView];
    }
}

- (void)handleSwipeRight {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self showMasterView];
    }
}

- (void)handleTap {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [self hideMasterView];
    }
}

- (void)addMasterButton {
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMasterView)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)removeMasterButton {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)showMasterView {
    if (!masterIsVisible) {
        masterIsVisible = YES;
        
        NSArray *controllers = self.splitViewController.viewControllers;
        UINavigationController *rootViewController = [controllers firstObject];
        
        UIView *rootView = rootViewController.view;
        CGRect rootFrame = rootView.frame;
        rootFrame.origin.x += rootFrame.size.width;
        
        [UIView beginAnimations:@"showView" context:NULL];
        rootView.frame = rootFrame;
        [UIView commitAnimations];
    }
}

- (void)hideMasterView {
    if (masterIsVisible) {
        masterIsVisible = NO;
        
        NSArray *controllers = self.splitViewController.viewControllers;
        UINavigationController *rootViewController = [controllers firstObject];
        
        UIView *rootView = rootViewController.view;
        CGRect rootFrame = rootView.frame;
        rootFrame.origin.x -= rootFrame.size.width;
        
        [UIView beginAnimations:@"showView" context:NULL];
        rootView.frame = rootFrame;
        [UIView commitAnimations];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self hideMasterView];
        [self removeMasterButton];
    } else {
        [self addMasterButton];
    }
}

@end