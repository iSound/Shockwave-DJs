//
//  SWDJs.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/15/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "SWMixCell.h"

#import "SWTopViewController.h"

@interface SWDJs : SWTopViewController <UICollectionViewDataSource, UICollectionViewDelegate>

// DJ Name
@property (nonatomic, strong) NSString *djName;

// Mix class list
@property (nonatomic, strong) NSString *mixClassList;

// DJ Color
@property (nonatomic, strong) UIColor *djColor;

// Cover (same as profilePic but distorted)
@property (nonatomic, strong) UIImageView *cover;

// Cover cover (darkens the cover)
@property (nonatomic, strong) UIView *coverCover;

// Last mix icon
@property (nonatomic, strong) UIImageView *profilePic;

// DJ Name Label
@property (nonatomic, strong) UILabel *djNameLabel;

// DJ Mix Amount
@property (nonatomic, strong) UILabel *djMixAmountLabel;

// Mix list
@property (nonatomic, strong) NSMutableArray *mixList;

// Mix Collection
@property (nonatomic, strong) UICollectionView *mixView;

- (id)initWithDJ:(NSString *)djName withColor:(UIColor *)djColor;
- (void)refresh;

@end