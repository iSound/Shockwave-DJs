//
//  SWAppDelegate.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 2/28/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <Parse/Parse.h>

#import "ECSlidingViewController.h"

#import "SWHomeViewController.h"
#import "SWMenuViewController.h"
#import "SWChatViewController.h"

#import "SWAudioPlayer.h"

@interface SWAppDelegate : UIResponder <UIApplicationDelegate, UISplitViewControllerDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@property (strong, nonatomic) SWAudioPlayer *audioPlayer;

- (void)playRecordedMix:(NSNotification *)notification;
- (void)pauseRecordedMix:(NSNotification *)notification;
- (void)resumeRecordedMix:(NSNotification *)notification;
- (void)playLiveMix:(NSNotification *)notification;
- (void)stopMix:(NSNotification *)notification;

@end