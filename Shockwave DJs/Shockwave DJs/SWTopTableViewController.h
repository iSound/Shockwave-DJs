//
//  SWTopTableViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWTableViewController.h"

@interface SWTopTableViewController : SWTableViewController {
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