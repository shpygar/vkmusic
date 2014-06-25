//
//  GFPlayerViewController.m
//  VKMusic
//
//  Created by Sergey Shpygar on 21.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import "GFPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GFSeekSlider.h"
#import "GFAudioPlayer.h"

@interface GFPlayerViewController () <GFSeekSliderDelegate, GFAudioPlayerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *topBar;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet GFSeekSlider *seekBar;
@property (strong, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedSeekLabel;
@property (strong, nonatomic) IBOutlet UILabel *helpLabel;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet MPVolumeView *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) NSTimer *timerUpdated;

@property (assign, nonatomic) BOOL sliderMoveEnabled;
@property (assign, nonatomic) CGFloat oldProgressValue;
@property (assign, nonatomic) CGFloat speedMovedSlider;

@property (strong, nonatomic) GFAudioPlayer *player;
@property (nonatomic, weak) id  playerItemCurrentTimeObserver;
@property (nonatomic, assign) CGFloat restoreAfterSeekRate;

- (IBAction)tooglePlay:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)toogleTopBar:(id)sender;
- (IBAction)showTimer:(id)sender;

@end

@implementation GFPlayerViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        _timerUpdated = [NSTimer scheduledTimerWithTimeInterval:1.f
//                                                         target:self
//                                                       selector:@selector(updateInformation)
//                                                       userInfo:nil
//                                                        repeats:YES];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self.timerUpdated invalidate];
    self.timerUpdated = nil;

    [self destroyPlayer];
}

-(void)destroyPlayer{
    if (self.playerItemCurrentTimeObserver) {
        [self.player.player removeTimeObserver:self.playerItemCurrentTimeObserver];
        self.playerItemCurrentTimeObserver = nil;
    }
    
    self.player.delegate = nil;
    [self.player destroyPlayer];
    self.player = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureWithAudio:self.audio];

    self.sliderMoveEnabled = YES;
    [self.seekBar setDelegate:self];
}

-(void)configureWithAudio:(VKAudio *)audio{
    [self destroyPlayer];
    
    self.titleLabel.text = audio.title;
    self.subtitleLabel.text = audio.artist;
    
    self.player = [GFAudioPlayer sharedManager];
    [self updateStatusWithAudioPlayer:self.player];
    self.player.delegate = self;
    self.player.path = audio.url;
    
}

-(void)setAudio:(VKAudio *)audio{
    _audio = audio;
    if (self.isViewLoaded) {
        [self configureWithAudio:audio];
    }
}

- (IBAction)tooglePlay:(id)sender{
    if ([self.player isPlaying]) {
        [self.player pause];
    }
    else{
        [self.player play];
    }
    [self updateStatusWithAudioPlayer:self.player];
}

- (IBAction)previous:(id)sender{
    
}

- (IBAction)next:(id)sender{
    
}

- (IBAction)share:(id)sender{
    
}

- (IBAction)toogleTopBar:(id)sender{
}

- (IBAction)showTimer:(id)sender{
    
}

#pragma mark -

-(void)changeY:(NSNumber *)value{
    if (self.sliderMoveEnabled==NO) {
        NSInteger change = [value intValue] - self.seekBar.frame.origin.y;
        if (change > 150) {
            self.speedSeekLabel.text = @"Точный скраббинг";
            self.speedMovedSlider = 0.0005f;
        }
        else if(change > 100){
            self.speedSeekLabel.text = @"Скорость скраббинга: 1/4";
            self.speedMovedSlider = 0.005f;
        }
        else if(change > 50){
            self.speedSeekLabel.text = @"Скорость скраббинга: 1/2";
            self.speedMovedSlider  = 0.05f;
        }
        else {
            self.speedSeekLabel.text = @"Скорость скраббинга: высокая";
            self.speedMovedSlider  = 1.0f;
        }
    }
}

-(void)updateInformation{
    [self updateStatusWithAudioPlayer:self.player];
}

- (NSString*) stringTime:(NSUInteger)duration {
	int min = floor(duration / 60);
	int sec = duration % 60;
    return [NSString stringWithFormat:@"%d:%02d", min, sec];
}

#pragma mark Slider

- (IBAction)progressSliderTouchUp:(UISlider*)sender {
	if (self.sliderMoveEnabled == NO) {
		
        float seconds = [sender value];
        
        [self.player.player seekToTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC)];

        self.sliderMoveEnabled = YES;
        
        self.speedSeekLabel.hidden =
        self.helpLabel.hidden = YES;
        
        self.numberLabel.hidden = NO;
    }
}

- (IBAction)progressSliderTouchDown:(UISlider*)sender {
	self.sliderMoveEnabled = NO;
    self.speedMovedSlider = 1.0f;
    self.speedSeekLabel.text = @"Скорость скраббинга: высокая";
    self.speedSeekLabel.hidden =
    self.helpLabel.hidden = NO;
    
    self.numberLabel.hidden = YES;
}

- (IBAction)progressSliderValueChanged:(UISlider*)sender {
    double duration = [self.audio.duration doubleValue];
	if (self.speedMovedSlider > 0) {
        sender.value = self.oldProgressValue + (sender.value - self.oldProgressValue)*self.speedMovedSlider;
    }
    else{
        sender.value = self.oldProgressValue + ((sender.value - self.oldProgressValue)>0 ? 1/duration : -1/duration);
    }
    self.oldProgressValue = sender.value;
    self.leftTimeLabel.text = [self stringTime:self.oldProgressValue];
	self.rightTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringTime:(duration - self.oldProgressValue)]];
}

#pragma mark - ITAudioPlayer Delegate

-(void)createPeriodicTimer{
    if (self.playerItemCurrentTimeObserver) {
        [self.player.player removeTimeObserver:self.playerItemCurrentTimeObserver];
        self.playerItemCurrentTimeObserver = nil;
    }
    self.playerItemCurrentTimeObserver = [self.player.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0f, NSEC_PER_SEC) queue:nil usingBlock:^(CMTime time) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateTimeWithAudioPlayer:self.player];
        });
    }];
}

-(void)updateStatusWithAudioPlayer:(GFAudioPlayer *)player{
    [self.playButton setSelected:[player isPlaying]];
    [self updateTimeWithAudioPlayer:player];
}

-(void)updateTimeWithAudioPlayer:(GFAudioPlayer *)player{
    if (self.sliderMoveEnabled) {
        
        float startSeconds = 0.f;
        float endSeconds = 1.f;
        float seconds = 0.0f;
        
        NSArray *seekableTimeRanges = [player.player.currentItem seekableTimeRanges];
        if ([seekableTimeRanges count] > 0)
        {
            NSValue *range = seekableTimeRanges[0];
            CMTimeRange timeRange = [range CMTimeRangeValue];
            
            startSeconds = CMTimeGetSeconds(timeRange.start);
            endSeconds = CMTimeGetSeconds(CMTimeRangeGetEnd(timeRange));
            seconds = CMTimeGetSeconds(player.player.currentTime);
            
            if (!self.playerItemCurrentTimeObserver && !self.restoreAfterSeekRate) {
                [self createPeriodicTimer];
            }
            
            if (seconds == endSeconds) {
                [self.player.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)];
            }
        }
        [self.seekBar setEnabled:endSeconds != 1.0f];
        [self.playButton setEnabled:endSeconds != 1.0f];
        
        [self.seekBar setMinimumValue:startSeconds];
        [self.seekBar setMaximumValue:endSeconds];
        [self.seekBar setValue:seconds animated:YES];
        
        self.leftTimeLabel.text = [self stringTime:floor(seconds - startSeconds)];
        self.rightTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringTime:floor(endSeconds - seconds)]];
	}
}



@end
