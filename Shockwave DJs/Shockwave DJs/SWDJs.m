//
//  SWDJs.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/15/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWDJs.h"

@interface SWDJs ()

@end

@implementation SWDJs

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = [NSString stringWithFormat:@"DJ %@", self.djName];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Tint color
    if ([self respondsToSelector:@selector(barTintColor)]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.barTintColor = self.djColor;
    } else {
        self.navigationController.navigationBar.tintColor = self.djColor;
    }
}

@end