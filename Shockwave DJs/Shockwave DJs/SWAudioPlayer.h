//
//  SWAudioPlayer.h
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/11/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>

@interface SWAudioPlayer : MPMoviePlayerController

@property (nonatomic, strong) PFObject *mixObject;

- (id)initWithMix:(PFObject *)object;
- (id)initWithLiveMix:(PFObject *)object;
- (void)play:(PFObject *)object;
- (void)resume;
- (void)prepareToPlay:(PFObject *)object;
- (void)setNowPlaying:(PFObject *)object;

- (void)updateDurationNowPlaying:(NSNotification *)notification;
- (void)donePlayingMix:(NSNotification *)notification;
- (void)metadataUpdate:(NSNotification *)notification;

@end