//
//  GFAudioPlayer.m
//  VKMusic
//
//  Created by Sergey Shpygar on 24/06/14.
//  Copyright (c) 2012 Sergey Shpygar. All rights reserved.
//

#import "GFAudioPlayer.h"
#import "GFPlaylist.h"
#import <MediaPlayer/MediaPlayer.h>


@interface GFAudioPlayer ()

@property (nonatomic, weak) id  playerItemCurrentTimeObserver;
@property (nonatomic, readonly) AVPlayer *player;

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

-(void)setCurrentTime:(CMTime)currentTime{
    [self.player seekToTime:currentTime];
}

-(CMTime)currentTime{
    return [self.player currentTime];
}

-(AVPlayerItem *)currentItem{
    return self.player.currentItem;
}

-(void)next{
    NSOrderedSet *audios = self.audio.playlist.audios;
    NSUInteger index =[audios indexOfObject:self.audio];
    if ( index != NSNotFound && index + 1 < audios.count ) {
        [self setAudio:audios[index + 1]];
    }
}

-(void)previous{
    NSOrderedSet *audios = self.audio.playlist.audios;
    NSUInteger index =[audios indexOfObject:self.audio];
    if ( index != NSNotFound && index > 0 ) {
        [self setAudio:audios[index - 1]];
    }
}

-(void)updateStatus{
    switch (self.player.currentItem.status) {
        case AVPlayerItemStatusReadyToPlay:
            break;
        case AVPlayerItemStatusFailed:
            [self next];
            NSLog(@"AVPlayerItemStatusFailed %@", self.player.currentItem.error);
            break;
        case AVPlayerItemStatusUnknown:
            break;
    }
    [self configureMediaInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate audioPlayerUpdatedStatus:self];
    });
}

-(void)createPeriodicTimer{
    if (self.playerItemCurrentTimeObserver) {
        [self.player removeTimeObserver:self.playerItemCurrentTimeObserver];
        self.playerItemCurrentTimeObserver = nil;
    }
    __weak GFAudioPlayer *wself = self;
    self.playerItemCurrentTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0f, NSEC_PER_SEC) queue:nil usingBlock:^(CMTime time) {
        [wself.delegate audioPlayerUpdatedCurrentTime:wself];
    }];
}

-(BOOL)isPlaying{
    return self.player && self.player.rate > 0;
}

- (void)setAudio:(GFAudio *)audio{
    if (_audio != audio) {
        _audio = audio;
        
        BOOL isPlaying = [self isPlaying];
        if (isPlaying) {
            [self pause];
        }
        [self destroyPlayer];
        if (audio) {
            NSURL *url = [NSURL URLWithString:audio.url];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
            [playerItem seekToTime:kCMTimeZero];
            _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            
            [self.delegate audioPlayerUpdatedCurrentAudio:self];
            
            [self createPeriodicTimer];
            
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
            if (isPlaying) {
                [self play];
            }
        }
    }
}

-(void)itemDidFinishPlaying:(NSNotification *) notification {
    // Will be called when AVPlayer finishes playing playerItem
    [self next];
    [self play];
}

- (void)destroyPlayer
{
	if (self.player){
		[self pause];
        if (self.playerItemCurrentTimeObserver) {
            [self.player removeTimeObserver:self.playerItemCurrentTimeObserver];
            self.playerItemCurrentTimeObserver = nil;
        }
        
        [self.player removeObserver:self forKeyPath:@"rate"];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"seekableTimeRanges"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
        
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
    else {
        [self updateStatus];
    }
}

-(void)updateSeekableTimeRanges{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate audioPlayerUpdatedSeekableTimeRanges:self];
    });
}

#pragma mark -

-(void) configureMediaInfo{
    //    MPMediaItemPropertyAlbumTitle
    //    MPMediaItemPropertyAlbumTrackCount
    //    MPMediaItemPropertyAlbumTrackNumber
    //    MPMediaItemPropertyArtist
    //    MPMediaItemPropertyArtwork
    //    MPMediaItemPropertyComposer
    //    MPMediaItemPropertyDiscCount
    //    MPMediaItemPropertyDiscNumber
    //    MPMediaItemPropertyGenre
    //    MPMediaItemPropertyPersistentID
    //    MPMediaItemPropertyPlaybackDuration
    //    MPMediaItemPropertyTitle
    
    GFPlaylist *playlist = self.audio.playlist;
    
    NSMutableDictionary *songInfo = @{MPMediaItemPropertyArtist : self.audio.artist,
                                      MPMediaItemPropertyTitle : self.audio.title,
                                      MPMediaItemPropertyAlbumTrackCount : @([playlist.audios count]),
                                     MPNowPlayingInfoPropertyPlaybackRate : @([self.player rate]),
                                      }.mutableCopy;
    if (playlist.title) {
        songInfo[MPMediaItemPropertyAlbumTitle] = playlist.title;
    }

    CGFloat duration = CMTimeGetSeconds([self.currentItem duration]);
    if (duration) {
        songInfo[MPMediaItemPropertyPlaybackDuration] = @(duration);
        songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(CMTimeGetSeconds(self.currentTime));
    }
    
    NSUInteger index = [playlist.audios indexOfObject:self.audio];
    if (index != NSNotFound) {
        songInfo[MPMediaItemPropertyAlbumTrackNumber] = @(index);
    }
    [songInfo setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"placeholder"]] forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}

@end
