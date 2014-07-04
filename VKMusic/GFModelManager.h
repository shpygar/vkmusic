//
//  GFModelManager.h
//  VKMusic
//
//  Created by Sergey Shpygar on 01.06.14.
//  Copyright (c) 2013 Sergey Shpygar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Helpers.h"

#import "GFAudio.h"
#import "GFPlaylist.h"

@interface GFModelManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (GFModelManager *)sharedManager;

- (void)saveContext;
- (NSURL *)documentsDirectory;

- (NSFetchRequest *)fetchRequestWithPlaylistID:(NSUInteger)playlistID;
- (NSFetchRequest *)fetchRequestWithPlaylistID:(NSUInteger)playlistID sortKey:(NSSortDescriptor*)sortKey;

@end
