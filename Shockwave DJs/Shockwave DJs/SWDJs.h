//
//  SWDJs.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/15/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWTopViewController.h"

@interface SWDJs : SWTopViewController

// DJ Name
@property (nonatomic, strong) NSString *djName;

// DJ Color
@property (nonatomic, strong) UIColor *djColor;

// Last mix icon
@property (nonatomic, strong) UIImageView *profilePic;

@end