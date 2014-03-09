//
//  SWHomeViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <iAd/iAd.h>

#import "SWTopTableViewController.h"

@interface SWHomeViewController : SWTopTableViewController <ADBannerViewDelegate> {
    ADBannerView *iAd;
}

@end