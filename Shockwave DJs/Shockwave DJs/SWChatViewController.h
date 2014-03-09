//
//  SWChatViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/4/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "SWTableViewController.h"

@interface SWChatViewController : SWTableViewController <PFLogInViewControllerDelegate> {
    NSString *username;
    
    NSMutableArray *chatArray;
    
    UITextField *messageBox;
    
    NSTimer *refreshTimer;
}

- (void)refresh;
- (void)liftToolbarWhenKeybordAppears:(NSNotification *)aNotification;
- (void)returnToolbarToInitialposition:(NSNotification *)aNotification;
- (void)submitMessage;

- (void)loginUser;
- (void)logoutUser;

@end