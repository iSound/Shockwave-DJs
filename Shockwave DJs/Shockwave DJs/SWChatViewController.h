//
//  SWChatViewController.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/4/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "SWTableViewController.h"

@interface SWChatViewController : SWTableViewController <PFLogInViewControllerDelegate, UIActionSheetDelegate> {
    NSString *username;
    
    NSMutableArray *chatArray;
    
    UITextField *messageBox;
    
    NSTimer *refreshTimer;
    
    UIActionSheet *adminOptions;
}

- (void)refresh;
- (void)liftToolbarWhenKeybordAppears:(NSNotification *)aNotification;
- (void)returnToolbarToInitialposition:(NSNotification *)aNotification;
- (IBAction)showAdminOptions:(id)sender;

- (void)loginUser;
- (void)logoutUser;
- (void)showAdminOptions;

@end