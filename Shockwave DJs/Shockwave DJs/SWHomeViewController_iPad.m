//
//  SWHomeViewController_iPad.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/3/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWHomeViewController_iPad.h"

@interface SWHomeViewController_iPad ()

@end

@implementation SWHomeViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS7_iPad"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS7_iPad"] forBarMetrics:UIBarMetricsDefault];
            }
        } else {
            if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS7_iPhone"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS7_iPhone"] forBarMetrics:UIBarMetricsDefault];
            }
        }
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS6_iPad"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS6_iPad"] forBarMetrics:UIBarMetricsDefault];
            }
        } else {
            if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS6_iPhone"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS6_iPhone"] forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS7_iPad"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS7_iPad"] forBarMetrics:UIBarMetricsDefault];
            }
        } else {
            if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS7_iPhone"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS7_iPhone"] forBarMetrics:UIBarMetricsDefault];
            }
        }
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS6_iPad"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS6_iPad"] forBarMetrics:UIBarMetricsDefault];
            }
        } else {
            if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_landscape_iOS6_iPhone"] forBarMetrics:UIBarMetricsDefault];
            } else if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"menuBackground_portrait_iOS6_iPhone"] forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 0;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end