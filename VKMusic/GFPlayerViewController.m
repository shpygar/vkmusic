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
#import "GFAudio.h"
#import "GFPlaylist.h"


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
    self.player.delegate = nil;
    self.player = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureWithAudio:nil];
    self.sliderMoveEnabled = YES;
    [self.seekBar setDelegate:self];
}

-(void)configureWithAudio:(GFAudio *)audio{
    self.player = [GFAudioPlayer sharedManager];
    self.player.delegate = self;
    if (audio) {
        self.player.audio = audio;
        [self.player play];
    }
    if ([self isViewLoaded]) {
        [self audioPlayerUpdatedCurrentAudio:self.player];
        [self audioPlayerUpdatedSeekableTimeRanges:self.player];
    }
}

- (IBAction)tooglePlay:(id)sender{
    if ([self.player isPlaying]) {
        [self.player pause];
    }
    else{
        [self.player play];
    }
}

- (IBAction)previous:(id)sender{
    [self.player previous];
}

- (IBAction)next:(id)sender{
    [self.player next];
}

- (IBAction)share:(id)sender {
    GFAudio *audio = self.player.audio;
    NSArray *items = @[[NSString stringWithFormat:@"Слушаю «%@. %@»", audio.title, audio.artist]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}


- (IBAction)toogleTopBar:(id)sender{
}

- (IBAction)showTimer:(id)sender{
    
}

#pragma mark -

-(void)changeY:(NSNumber *)value{
    if (!self.sliderMoveEnabled) {
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

- (NSString*) stringTime:(NSUInteger)duration {
	NSUInteger min = floor(duration / 60);
	NSUInteger sec = floor(duration % 60);
    return [NSString stringWithFormat:@"%d:%02d", min, sec];
}

#pragma mark Slider

- (IBAction)progressSliderTouchUp:(UISlider*)sender {
	if (self.sliderMoveEnabled == NO) {
		
        float seconds = [sender value];
        
        [self.player setCurrentTime:CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC)];

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
    double duration = sender.maximumValue - sender.minimumValue;
    if (self.speedMovedSlider > 0) {
        sender.value = self.oldProgressValue + (sender.value - self.oldProgressValue)*self.speedMovedSlider;
    }
    else{
        sender.value = self.oldProgressValue + ((sender.value - self.oldProgressValue)>0 ? 1/duration : -1/duration);
    }
    self.oldProgressValue = sender.value;
    
    [self updateTimeLabelsWithCurrentTime:self.oldProgressValue];
}

#pragma mark - ITAudioPlayer Delegate

-(void)audioPlayerUpdatedStatus:(GFAudioPlayer *)player{
    [self.playButton setSelected:[player isPlaying]];
    [self audioPlayerUpdatedSeekableTimeRanges:player];
}

-(void)audioPlayerUpdatedCurrentAudio:(GFAudioPlayer *)player{
    self.titleLabel.text = player.audio.title;
    self.subtitleLabel.text = player.audio.artist;
    GFPlaylist *playlist = self.player.audio.playlist;
    NSUInteger currentIndex = [playlist.audios indexOfObject:self.player.audio];
    if (currentIndex != NSNotFound) {
        NSUInteger countAudios = [playlist.audios count];
        self.numberLabel.text = [NSString stringWithFormat:@"%d из %d", currentIndex + 1, countAudios];
        [self.previousButton setEnabled:(currentIndex > 0)];
        [self.nextButton setEnabled:(currentIndex < countAudios - 1)];
    }
    [self audioPlayerUpdatedStatus:player];
}

-(void)audioPlayerUpdatedCurrentTime:(GFAudioPlayer *)player{
    if (self.sliderMoveEnabled) {
        float seconds = CMTimeGetSeconds(player.currentTime);
        [self.seekBar setValue:seconds animated:YES];
        
        [self updateTimeLabelsWithCurrentTime:seconds];
    }
}

-(void)audioPlayerUpdatedSeekableTimeRanges:(GFAudioPlayer *)player{
    if (self.sliderMoveEnabled) {
        NSArray *seekableTimeRanges = [self.player.currentItem seekableTimeRanges];
        float startSeconds = 0, endSeconds = 0;
        if ([seekableTimeRanges count] > 0)
        {
            NSValue *range = seekableTimeRanges[0];
            CMTimeRange timeRange = [range CMTimeRangeValue];
            
            startSeconds = CMTimeGetSeconds(timeRange.start);
            endSeconds = CMTimeGetSeconds(timeRange.duration);
        }
        [self.seekBar setEnabled:endSeconds != 0.0f];
        [self.playButton setEnabled:endSeconds != 0.0f];
        
        [self.seekBar setMinimumValue:startSeconds];
        [self.seekBar setMaximumValue:endSeconds];
        
        [self audioPlayerUpdatedCurrentTime:player];
	}
}

-(void)updateTimeLabelsWithCurrentTime:(CGFloat)seconds{
    self.leftTimeLabel.text = [self stringTime:floor(seconds - self.seekBar.minimumValue)];
    self.rightTimeLabel.text = [NSString stringWithFormat:@"-%@", [self stringTime:floor(self.seekBar.maximumValue - seconds)]];

}

@end
