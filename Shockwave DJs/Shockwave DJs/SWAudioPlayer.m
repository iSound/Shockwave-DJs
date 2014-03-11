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
    mixObject = object;
    return [super initWithContentURL:[NSURL URLWithString:mixObject[@"url"]]];
}

- (void)play {
    [super play];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error) {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [errorAlert show];
            });
        }
    });
}

- (void)pause {
    [super pause];
}

- (void)stop {
    [super stop];
}

- (void)prepareToPlay {
    [super prepareToPlay];
}

@end