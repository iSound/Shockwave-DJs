//
//  SWHomeViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>
#import <iAd/iAd.h>

#import "SWTopTableViewController.h"

@interface SWHomeViewController : SWTopTableViewController <ADBannerViewDelegate> {
    NSMutableArray *feedContent;
    
    BOOL bannerIsVisible;
    
    ADBannerView *iAd;
}

- (void)refresh;
- (void)updatePlayerToolbar:(NSNotification *)notification;
- (void)play;
- (void)pause;
- (void)stop;

@end