//
//  GFModelManager.m
//  VKMusic
//
//  Created by Sergey Shpygar on 01.06.14.
//  Copyright (c) 2013 Sergey Shpygar. All rights reserved.
//

#import "GFModelManager.h"

@interface GFModelManager ()

@end

@implementation GFModelManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (GFModelManager *)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.undoManager = nil;
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    
    NSURL *storeURL = [[self documentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
   
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
//        NSURL *bundleStoreURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"sqlite"];
//        [[NSFileManager defaultManager] copyItemAtURL:bundleStoreURL toURL:storeURL error:&error];
//        
//        NSURL *storeURLSHM = [[self documentsDirectory] URLByAppendingPathComponent:@"Model.sqlite-shm"];
//        NSURL *bundleStoreURLSHM = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"sqlite-shm"];
//        [[NSFileManager defaultManager] copyItemAtURL:bundleStoreURLSHM toURL:storeURLSHM error:&error];
//        
//        NSURL *storeURLWAL = [[self documentsDirectory] URLByAppendingPathComponent:@"Model.sqlite-wal"];
//        NSURL *bundleStoreURLWAL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"sqlite-wal"];
//        [[NSFileManager defaultManager] copyItemAtURL:bundleStoreURLWAL toURL:storeURLWAL error:&error];
//    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES,
                              NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}
                              };
    
    // Check if we need a migration
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
    NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
    BOOL isModelCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    if (! isModelCompatible) {
        // We need a migration, so we set the journal_mode to DELETE
        options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                    NSInferMappingModelAutomaticallyOption:@YES,
                    NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
                    };
    }
    
    NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (! persistentStore) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Reinstate the WAL journal_mode
    if (! isModelCompatible) {
        [_persistentStoreCoordinator removePersistentStore:persistentStore error:NULL];
        options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                    NSInferMappingModelAutomaticallyOption:@YES,
                    NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}
                    };
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    }
    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSFetchRequest *)fetchRequestWithPlaylistID:(NSUInteger)playlistID{
    return [self fetchRequestWithPlaylistID:playlistID sortKey:nil];
}

- (NSFetchRequest *)fetchRequestWithPlaylistID:(NSUInteger)playlistID sortKey:(NSSortDescriptor *)sortKey{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:[GFAudio entityName] inManagedObjectContext:[GFModelManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    if (playlistID) {
        NSPredicate *authorPredicate = [NSPredicate predicateWithFormat:@"playlist.playlistID == %@", @(playlistID)];
       [fetchRequest setPredicate:authorPredicate];
    }
    
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSMutableArray* keys = @[].mutableCopy;
    if (sortKey) {
        [keys addObject:sortKey];
    }
    [keys addObject:[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]];
    
    [fetchRequest setSortDescriptors:keys];
    return fetchRequest;
}


@end
