//
//  SWAudioPlayer.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/11/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWAudioPlayer.h"

@implementation SWAudioPlayer

- (id)initWithMix:(PFObject *)object {
    return [super initWithContentURL:[NSURL URLWithString:object[@"url"]]];
    if (self) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            mixObject = object;
            
            NSError *error;
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
            [[AVAudioSession sharedInstance] setDelegate:[[UIApplication sharedApplication] delegate]];
            if (error) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [errorAlert show];
                });
            }
        });
    }
    return self;
}

- (void)play {
    [super play];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        if (error) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [errorAlert show];
            });
        }
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    });
}

- (void)pause {
    [super pause];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
        if (error) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [errorAlert show];
            });
        }
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    });
}

- (void)stop {
    [super stop];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
        if (error) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [errorAlert show];
            });
        }
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    });
}

- (void)prepareToPlay {
    [super prepareToPlay];
}

@end