#import "GFAudio.h"

@interface GFAudio ()

// Private interface goes here.

@end


@implementation GFAudio

// Custom logic goes here.

@end

@implementation GFAudio (GFMappingManager)

- (void)setValuesWithVKAudio:(VKAudio *) audio
{
    self.title = audio.title;
    self.url = audio.url;
    self.duration = audio.duration;
    self.artist = audio.artist;
}

@end