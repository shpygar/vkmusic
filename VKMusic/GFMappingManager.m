//
//  GFMappingManager.m
//  VKMusic
//
//  Created by Sergey Shpygar on 25.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import "GFMappingManager.h"
#import "NSManagedObjectContext+Helpers.h"
#import "GFModelManager.h"
#import "GFAudio.h"
#import "VKAudio.h"
#import "GFPlaylist.h"

@implementation GFMappingManager

- (BOOL)importVKAudio:(VKAudio *)vkaudio audio:(GFAudio *__autoreleasing *)audioPointer context:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error
{
    GFAudio *audio = *audioPointer;
    
    if (! audio) {
        audio = [context objectWithEntityName:[GFAudio entityName] value:vkaudio.id forKey:@"audioID"];
    }
    
    if (! audio) {
        audio = [GFAudio insertInManagedObjectContext:context];
        audio.audioID = vkaudio.id;
    }
    
    [audio setValuesWithVKAudio:vkaudio];
    
    *audioPointer = audio;

    return YES;
}

- (GFPlaylist *)importAudios:(NSArray *)audios toPlaylist:(GFPlaylist *__autoreleasing *)toPlaylistPointer context:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error
{
    GFPlaylist *toPlaylist = *toPlaylistPointer;
    
    NSMutableArray *modifiedAudios = [NSMutableArray arrayWithCapacity:[audios count]];
    for (VKAudio *vkaudio in audios) {
        GFAudio *audio = nil;
        if ([self importVKAudio:vkaudio audio:&audio context:context error:error]){
            [audio setPlaylist:toPlaylist];
            [modifiedAudios addObject:audio];
        };
    }
    
    // Удаляем из локальной базы объекты, которых больше нет на сервере.

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[GFAudio entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", modifiedAudios];
    NSArray *removedBooks = [context executeFetchRequest:request error:nil];
    [removedBooks enumerateObjectsUsingBlock:^(GFAudio *audio, NSUInteger idx, BOOL *stop) {
//        if (!audio.isLocal) {
            [context deleteObject:audio];
//        }
    }];

    return toPlaylist;
}


@end
