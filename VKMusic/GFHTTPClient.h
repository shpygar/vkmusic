//
//  GFHTTPClient.h
//  VKMusic
//
//  Created by Sergey Shpygar on 01.06.14.
//  Copyright (c) 2013 Sergey Shpygar. All rights reserved.
//


#import "GFModelManager.h"


typedef void (^GFHTTPClientCompletionBlock)(BOOL success, NSError *error);
typedef void (^GFHTTPClientPlaylistCompletionBlock)(GFPlaylist *playlist, BOOL success, NSError *error);

@interface GFHTTPClient : NSObject

+ (instancetype)sharedClient;

-(void)getAudiosOfPlaylist:(NSUInteger)playlistID completion:(GFHTTPClientPlaylistCompletionBlock)completion;
-(void)logout;

@end
