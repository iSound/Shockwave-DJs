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
    self.mixObject = object;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDurationNowPlaying:) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donePlayingMix:) name:MPMoviePlayerPlaybackDidFinishNotification object:object];
    return [self initWithContentURL:[NSURL URLWithString:[object objectForKey:@"url"]]];
}

- (id)initWithLiveMix:(PFObject *)object {
    self.mixObject = object;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donePlayingMix:) name:MPMoviePlayerPlaybackDidFinishNotification object:object];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(metadataUpdate:) name:MPMoviePlayerTimedMetadataUpdatedNotification object:nil];
    return [self initWithContentURL:[NSURL URLWithString:[object objectForKey:@"url"]]];
}

- (id)initWithContentURL:(NSURL *)url {
    self.controlStyle = MPMovieControlStyleEmbedded;
    return [super initWithContentURL:url];
}

- (void)play:(PFObject *)object {
    [super play];
    [self setNowPlaying:object];
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [errorAlert show];
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playingMix" object:nil userInfo:nil];
}

- (void)resume {
    [self play:self.mixObject];
}

- (void)pause {
    [super pause];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pausedMix" object:nil userInfo:nil];
}

- (void)stop {
    [super stop];
    [self.mixObject incrementKey:@"plays"];
    [self.mixObject saveEventually];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doneMix" object:nil userInfo:nil];
}

- (void)prepareToPlay:(PFObject *)object {
    [super prepareToPlay];
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setDelegate:[[UIApplication sharedApplication] delegate]];
    if (error) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [errorAlert show];
        });
    }
}

- (void)setNowPlaying:(PFObject *)object {
    MPNowPlayingInfoCenter *nowPlayingCenter = [MPNowPlayingInfoCenter defaultCenter];
    if ([nowPlayingCenter nowPlayingInfo] != nil) {
        [nowPlayingCenter setNowPlayingInfo:nil];
    }
    NSMutableDictionary *mixInfo = [[NSMutableDictionary alloc] init];
    [mixInfo setObject:object[@"artist"] forKey:MPMediaItemPropertyArtist];
    [mixInfo setObject:@"Shockwave DJs" forKey:MPMediaItemPropertyAlbumArtist];
    [mixInfo setObject:object[@"name"] forKey:MPMediaItemPropertyTitle];
    [mixInfo setObject:@"Hip-Hop/Rap" forKey:MPMediaItemPropertyGenre];
    [mixInfo setObject:[NSNumber numberWithDouble:[self duration]] forKey:MPMediaItemPropertyPlaybackDuration];
    [nowPlayingCenter setNowPlayingInfo:mixInfo];
    // Async loading of image
    NSURL *url = [NSURL URLWithString:[object objectForKey:@"iconURL"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    url = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:data]];
            NSMutableDictionary *newMixInfo = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
            [newMixInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
            if ([[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo] != nil) {
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
            }
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:newMixInfo];
        }
    }];
    request = nil;
}

- (void)updateDurationNowPlaying:(NSNotification *)notification {
    NSMutableDictionary *newMixInfo = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    [newMixInfo setObject:[NSNumber numberWithDouble:[self duration]] forKey:MPMediaItemPropertyPlaybackDuration];
    if ([[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo] != nil) {
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:newMixInfo];
}

- (void)donePlayingMix:(NSNotification *)notification {
    [(PFObject *)[notification object] incrementKey:@"plays"];
    [(PFObject *)[notification object] saveEventually];
}

- (void)metadataUpdate:(NSNotification *)notification {
    NSMutableDictionary *newMixInfo = [NSMutableDictionary dictionaryWithDictionary:[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo]];
    
    MPTimedMetadata *firstMeta = [self.timedMetadata objectAtIndex:0];
    NSArray *tempArray = [firstMeta.value componentsSeparatedByString:@" - "];
    [newMixInfo setObject:[tempArray objectAtIndex:0] forKey:MPMediaItemPropertyArtist];
    [newMixInfo setObject:[tempArray objectAtIndex:1] forKey:MPMediaItemPropertyAlbumTitle];
    [newMixInfo setObject:[tempArray objectAtIndex:2] forKey:MPMediaItemPropertyTitle];
    if ([[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo] != nil) {
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:newMixInfo];
}

@end