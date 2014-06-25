//
//  GFAudioPlayer.m
//  VKMusic
//
//  Created by Sergey Shpygar on 24/06/14.
//  Copyright (c) 2012 Sergey Shpygar. All rights reserved.
//

#import "GFAudioPlayer.h"

@interface GFAudioPlayer ()

@end


@implementation GFAudioPlayer

#pragma mark ---- singleton object methods ---

+ (GFAudioPlayer *)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
    }
    return self;
}

-(void)pause{
    [self.player pause];
}

-(void)play{
    [self.player play];
}

-(void)updateStatus{
    switch (self.player.currentItem.status) {
        case AVPlayerItemStatusReadyToPlay:
            break;
        case AVPlayerItemStatusFailed:
            NSLog(@"AVPlayerItemStatusFailed %@", self.player.currentItem.error);
            break;
        case AVPlayerItemStatusUnknown:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(updateStatusWithAudioPlayer:)]) {
        [self.delegate updateStatusWithAudioPlayer:self];
    }
}

-(void)updateSeekableTimeRanges{
    if ([self.delegate respondsToSelector:@selector(updateTimeWithAudioPlayer:)]) {
        [self.delegate updateTimeWithAudioPlayer:self];
    }  
}

-(BOOL)isPlaying{
    return self.player && self.player.rate > 0;
}

- (void)setPath:(NSString *)path{
    _path = path;
	[self destroyPlayer];
    
    if (path) {
        NSURL *url = [NSURL URLWithString:path];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        [playerItem seekToTime:kCMTimeZero];
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [self.player addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
   
        [self.player.currentItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
       
        [self.player.currentItem addObserver:self
                                  forKeyPath:@"seekableTimeRanges"
                                     options:NSKeyValueObservingOptionNew
                                     context:nil];
    }
}

- (void)destroyPlayer
{
	if (self.player){
		[self.player pause];
      
        [self.player removeObserver:self forKeyPath:@"rate"];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"seekableTimeRanges"];
        
       _player = nil;
    }
}

-(void)dealloc{
    [self destroyPlayer];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"seekableTimeRanges"]) {
        [self updateSeekableTimeRanges];
    }
    else{
        [self updateStatus];
    }
}
@end
