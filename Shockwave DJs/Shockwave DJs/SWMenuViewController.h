//
//  SWMenuViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWHomeViewController.h"

#import "SWChatViewController.h"

#import "SWTableViewController.h"

@interface SWMenuViewController : SWTableViewController {
    NSArray *section0;
    NSArray *section1;
    NSArray *section2;
}

- (void)home;

- (void)amatterfact;
- (void)unknown;
- (void)bloodshot;
- (void)lovell;

- (void)facebook;
- (void)twitter;
- (void)instagram;
- (void)google;
- (void)website;
- (void)email;
- (void)chat;

@end