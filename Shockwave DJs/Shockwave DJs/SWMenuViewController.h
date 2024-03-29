//
//  SWMenuViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "SWHomeViewController.h"

#import "SWDJs.h"

#import "SWChatViewController.h"

#import "SWTableViewController.h"

@interface SWMenuViewController : SWTableViewController <MFMailComposeViewControllerDelegate> {
    NSArray *sections;
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