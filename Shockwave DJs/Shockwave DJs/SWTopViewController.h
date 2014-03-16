//
//  SWTopViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/15/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWViewController.h"

@interface SWTopViewController : SWViewController {
    BOOL masterIsVisible;
}

- (void)showLeftMenu;
- (void)showRightChat;

- (void)handleSwipeLeft;
- (void)handleSwipeRight;
- (void)handleTap;
- (void)addMasterButton;
- (void)removeMasterButton;
- (void)showMasterView;
- (void)hideMasterView;

@end