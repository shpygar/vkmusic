//
//  NSManagedObjectContext+Helpers.m
//  VKMusic
//
//  Created by Sergey Shpygar on 01.06.14.
//  Copyright (c) 2013 Sergey Shpygar. All rights reserved.
//

#import "NSManagedObjectContext+Helpers.h"

@implementation NSManagedObjectContext (Helpers)

- (NSArray *)objectsWithEntityName:(NSString *)entityName values:(NSSet *)values forKey:(NSString *)key
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"%K IN %@", key, values];

    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    
    return results;
}

- (id)objectWithEntityName:(NSString *)entityName value:(id)value forKey:(NSString *)key
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    request.fetchOffset = 0;
    request.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    
    id object = ([results count] > 0 ? results[0] : nil);
    return object;
}

@end
