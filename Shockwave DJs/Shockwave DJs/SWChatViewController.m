//
//  SWChatViewController.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/4/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWChatViewController.h"

@interface SWChatViewController ()

@end

@implementation SWChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Chat";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    } else {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 980, 320, 44));
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    CGImageRelease(imageRef);
    
    messageBox = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 213, 25)];
    if ([messageBox respondsToSelector:@selector(tintColor)]) {
        messageBox.tintColor = [UIColor whiteColor];
    }
    messageBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    messageBox.keyboardAppearance = UIKeyboardAppearanceAlert;
    messageBox.textColor = [UIColor whiteColor];
    messageBox.returnKeyType = UIReturnKeySend;
    // messageBox.borderStyle = UITextBorderStyleRoundedRect;
    messageBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"<#string#>" attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil], [[UIBarButtonItem alloc] initWithCustomView:messageBox], [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftToolbarWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToolbarToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [messageBox endEditing:messageBox.editing];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    } else {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    }
}

- (void)liftToolbarWhenKeybordAppears:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y - keyboardFrame.size.width, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
    } else {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y - keyboardFrame.size.height, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
    }
    [UIView commitAnimations];
}

- (void)returnToolbarToInitialposition:(NSNotification *)aNotification {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y + keyboardFrame.size.width, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
    } else {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y + keyboardFrame.size.height, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
    }
    [UIView commitAnimations];
}

@end