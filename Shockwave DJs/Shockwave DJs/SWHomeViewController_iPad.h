//
//  SWHomeViewController_iPad.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/3/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>
#import <iAd/iAd.h>

#import "SWTableViewController.h"

@interface SWHomeViewController_iPad : SWTableViewController <ADBannerViewDelegate> {
    NSMutableArray *feedContent;
    
    ADBannerView *iAd;
}

- (void)refresh;
- (void)updatePlayerToolbar:(NSNotification *)notification;
- (void)playMix;
- (void)pauseMix;
- (void)stopMix;

@end