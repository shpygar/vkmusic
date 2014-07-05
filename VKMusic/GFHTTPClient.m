//
//  GFHTTPClient.m
//  VKMusic
//
//  Created by Sergey Shpygar on 01.06.14.
//  Copyright (c) 2013 Sergey Shpygar. All rights reserved.
//


#import "GFHTTPClient.h"
#import "GFMappingManager.h"
#import "GFModelManager.h"
#import "VKSdk.h"


@interface GFHTTPClient ()

@property (nonatomic, strong) GFMappingManager *objectsParser;
@property (nonatomic, assign, getter = isUpdating) BOOL updating;

@end

@implementation GFHTTPClient

+ (instancetype)sharedClient
{
    // singleton initialization
    
    static dispatch_once_t pred = 0;
    __strong static id client = nil;
    dispatch_once(&pred, ^{
        client = [[self alloc] init];
    });
    return client;
}

- (GFMappingManager *)objectsParser
{
    if (! _objectsParser) {
        _objectsParser = [[GFMappingManager alloc] init];
    }
    return _objectsParser;
}

-(void)getAudiosOfPlaylist:(NSUInteger)playlistID completion:(GFHTTPClientPlaylistCompletionBlock)completion{
    NSString *userId = [VKSdk getAccessToken].userId;
    VKRequest * audioReq = [VKApi requestWithMethod:@"audio.get"
                                      andParameters:@{VK_API_OWNER_ID : userId} andHttpMethod:@"GET"];
	[audioReq executeWithResultBlock: ^(VKResponse *response) {
	    VKAudios *audios = [[VKAudios alloc] initWithDictionary:response.json objectClass:[VKAudio class]];
        if (audios.items) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GFPlaylist *playlist = nil;
                NSManagedObjectContext *context = [GFModelManager sharedManager].managedObjectContext;
                NSError *error = nil;
                playlist = [context objectWithEntityName:[GFPlaylist entityName] value:@(playlistID) forKey:@"playlistID"];
                if (! playlist) {
                    playlist = [GFPlaylist insertInManagedObjectContext:context];
                    playlist.playlistID = @(playlistID);
                }
                
                [self.objectsParser importAudios:audios.items
                                      toPlaylist:&playlist
                                         context:context
                                           error:&error];
                
                [context processPendingChanges];
                if ([context hasChanges]) {
                    [context save:&error];
                }
                if (completion) {
                    completion(playlist, YES, nil);
                }
            });
        }
        else{
            if (completion) {
                completion(nil, NO, nil);
            }
        }
    }
    errorBlock: ^(NSError *error) {
        if (completion) {
            completion(nil, NO, error);
        }
    }];
}

-(void)logout{
    [VKSdk forceLogout];
    [[GFModelManager sharedManager] reset];
}

@end
