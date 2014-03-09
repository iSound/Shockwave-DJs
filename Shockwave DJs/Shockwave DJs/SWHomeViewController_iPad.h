//
//  SWHomeViewController_iPad.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/3/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <iAd/iAd.h>

#import "SWTableViewController.h"

@interface SWHomeViewController_iPad : SWTableViewController <ADBannerViewDelegate> {
    ADBannerView *iAd;
}

@end