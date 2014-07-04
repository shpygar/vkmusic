//
//  GFMappingManager.h
//  VKMusic
//
//  Created by Sergey Shpygar on 25.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GFPlaylist;

@interface GFMappingManager : NSObject

- (GFPlaylist *)importAudios:(NSArray *)audios toPlaylist:(GFPlaylist *__autoreleasing *)toPlaylistPointer context:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error;

@end
