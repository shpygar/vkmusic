#import "_GFAudio.h"
#import "GFMappingManager.h"
#import "VKAudio.h"

@interface GFAudio : _GFAudio {}
// Custom logic goes here.
@end

@interface GFAudio (GFMappingManager)

- (void)setValuesWithVKAudio:(VKAudio *) audio;

@end

@interface GFAudio (NSPredicate)

+ (NSPredicate*)predicateForSearchText:(NSString*)searchText;

@end
