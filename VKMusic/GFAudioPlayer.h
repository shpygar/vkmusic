//
//  GFAudioPlayer.h
//  VKMusic
//
//  Created by Sergey Shpygar on 24/06/14.
//  Copyright (c) 2012 Sergey Shpygar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GFAudio.h"

@class GFAudioPlayer;

@protocol GFAudioPlayerDelegate <NSObject>

- (void)audioPlayerUpdatedCurrentAudio:(GFAudioPlayer *)player;
- (void)audioPlayerUpdatedStatus:(GFAudioPlayer *)player;
- (void)audioPlayerUpdatedCurrentTime:(GFAudioPlayer *)player;
- (void)audioPlayerUpdatedSeekableTimeRanges:(GFAudioPlayer *)player;

@end


@interface GFAudioPlayer : NSObject

@property (strong, nonatomic) GFAudio *audio;
@property (assign, nonatomic) CMTime currentTime;
@property (weak, readonly) AVPlayerItem *currentItem;

+ (GFAudioPlayer *)sharedManager;

@property (nonatomic, readonly, getter = isPlaying)	BOOL playing;
@property (nonatomic, weak) id<GFAudioPlayerDelegate> delegate;

- (void) destroyPlayer;

- (void) pause;
- (void) play;

-(void) next;
-(void) previous;

@end
