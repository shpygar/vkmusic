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

@implementation GFAudio (NSPredicate)

+ (NSPredicate*)predicateForSearchText:(NSString*)searchText {
    if ([searchText length]) {
        searchText = [searchText stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSArray*  searchWords = [searchText componentsSeparatedByString:@" "];
        NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:searchWords.count];
        for (NSString *word in searchWords) {
            NSMutableArray* predicatesOfWord = [NSMutableArray array];
            [predicatesOfWord addObject:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", word]];
            [predicatesOfWord addObject:[NSPredicate predicateWithFormat:@"artist CONTAINS[cd] %@", word]];
            
            [predicates addObject:[NSCompoundPredicate orPredicateWithSubpredicates:predicatesOfWord]];
        }
        return [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    }
    else{
        return nil;
    }
}


@end