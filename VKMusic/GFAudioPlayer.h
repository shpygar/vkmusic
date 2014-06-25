//
//  GFAudioPlayer.h
//  VKMusic
//
//  Created by Sergey Shpygar on 24/06/14.
//  Copyright (c) 2012 Sergey Shpygar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class GFAudioPlayer;

@protocol GFAudioPlayerDelegate <NSObject>

- (void)updateStatusWithAudioPlayer:(GFAudioPlayer *)player;
- (void)updateTimeWithAudioPlayer:(GFAudioPlayer *)player;

@end


@interface GFAudioPlayer : NSObject

@property (strong, nonatomic) NSString *path;
@property (nonatomic, readonly) AVPlayer *player;

+ (GFAudioPlayer *)sharedManager;

@property (nonatomic, readonly, getter = isPlaying)	BOOL playing;
@property (nonatomic, weak) id<GFAudioPlayerDelegate> delegate;

- (void) destroyPlayer;
- (void) pause;
- (void) play;

@end
