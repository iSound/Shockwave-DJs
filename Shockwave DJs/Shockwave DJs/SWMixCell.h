//
//  SWMixCell.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/16/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

@interface SWMixCell : UICollectionViewCell

@property (nonatomic, strong) UIActivityIndicatorView *loadingCover;

@property (nonatomic, strong) UIImageView *albumArt;

@property (nonatomic, strong) UIView *highlight;

- (void)setAlbumCover:(NSURL *)imageUrl;

- (void)highlightCell;
- (void)unHighlightCell;

@end