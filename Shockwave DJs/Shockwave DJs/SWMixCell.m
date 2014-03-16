//
//  SWMixCell.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/16/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWMixCell.h"

@implementation SWMixCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Motion Effect
        if ([self respondsToSelector:@selector(addMotionEffect:)]) {
            UIInterpolatingMotionEffect *xTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            xTilt.minimumRelativeValue = [NSNumber numberWithFloat: -15];
            xTilt.maximumRelativeValue = [NSNumber numberWithFloat: 15];
            
            UIInterpolatingMotionEffect *yTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            yTilt.minimumRelativeValue = [NSNumber numberWithFloat: -15];
            yTilt.maximumRelativeValue = [NSNumber numberWithFloat: 15];
            
            UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
            group.motionEffects = @[xTilt, yTilt];
            [self addMotionEffect:group];
        }
        // Background Color
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        // Loading Cover
        self.loadingCover = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.loadingCover setFrame:CGRectMake(frame.size.width/2 - self.loadingCover.frame.size.width/2, frame.size.width/2 - self.loadingCover.frame.size.height/2, self.loadingCover.frame.size.width, self.loadingCover.frame.size.height)];
        
        [self addSubview:self.loadingCover];
        [self.loadingCover startAnimating];
        
        // Album Cover
        self.albumArt = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.albumArt.contentMode = UIViewContentModeRedraw;
        
        // Plays
        self.plays = [[UILabel alloc] initWithFrame:self.albumArt.frame];
        self.plays.textColor = [UIColor whiteColor];
        self.plays.backgroundColor = self.backgroundColor;
        self.plays.font = [UIFont fontWithName:self.plays.font.fontName size:self.plays.frame.size.width/4];
        
        // Mix title
        self.mixTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.albumArt.frame.size.height, self.frame.size.width, self.frame.size.height - self.albumArt.frame.size.height)];
        self.mixTitle.textColor = [UIColor lightTextColor];
        self.mixTitle.font = [UIFont fontWithName:self.mixTitle.font.fontName size:self.mixTitle.frame.size.height/2];
        self.mixTitle.numberOfLines = 3;
        self.mixTitle.adjustsFontSizeToFitWidth = YES;
        self.mixTitle.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setAlbumCover:(NSURL *)imageUrl {
    // Async loading of posters
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.albumArt.image = nil;
        if (!error) {
            self.albumArt.image = [UIImage imageWithData:data];
            // cell.imageView.layer.cornerRadius = cell.frame.size.height/2;
            // cell.imageView.layer.masksToBounds = YES;
        }
        [self.loadingCover stopAnimating];
        [self.loadingCover removeFromSuperview];
        [self insertSubview:self.albumArt belowSubview:self.plays];
    }];
    request = nil;
}

- (void)setNumberOfPlays:(int)playInt {
    self.plays.text = [NSString stringWithFormat:@" ▶︎ %d ", playInt];
    [self.plays sizeToFit];
    [self.plays setFrame:CGRectMake(self.albumArt.frame.size.width/2 - self.plays.frame.size.width/2, self.albumArt.frame.size.height/2 - self.plays.frame.size.height/2, self.plays.frame.size.width, self.plays.frame.size.height)];
    self.plays.layer.cornerRadius = self.plays.frame.size.height/2;
    self.plays.layer.masksToBounds = YES;
    [self addSubview:self.plays];
}

- (void)setTitleOfMix:(NSString *)title {
    self.mixTitle.text = title;
    [self addSubview:self.mixTitle];
}

- (void)highlightCell {
    if (self.highlight == nil) {
        self.highlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.highlight.backgroundColor = [UIColor lightTextColor];
    }
    [self addSubview:self.highlight];
}

- (void)unHighlightCell {
    [self.highlight removeFromSuperview];
    self.highlight = nil;
}

@end