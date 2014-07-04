//
//  NSManagedObjectContext+Helpers.h
//  VKMusic
//
//  Created by Sergey Shpygar on 01.06.14.
//  Copyright (c) 2013 Sergey Shpygar. All rights reserved.
//


#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Helpers)

- (NSArray *)objectsWithEntityName:(NSString *)entityName values:(NSSet *)values forKey:(NSString *)key;
- (id)objectWithEntityName:(NSString *)entityName value:(id)value forKey:(NSString *)key;

@end
