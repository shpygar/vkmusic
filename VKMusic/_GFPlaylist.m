// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GFPlaylist.m instead.

#import "_GFPlaylist.h"

const struct GFPlaylistAttributes GFPlaylistAttributes = {
	.playlistID = @"playlistID",
	.title = @"title",
};

const struct GFPlaylistRelationships GFPlaylistRelationships = {
	.audios = @"audios",
};

const struct GFPlaylistFetchedProperties GFPlaylistFetchedProperties = {
};

@implementation GFPlaylistID
@end

@implementation _GFPlaylist

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Playlist";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Playlist" inManagedObjectContext:moc_];
}

- (GFPlaylistID*)objectID {
	return (GFPlaylistID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"playlistIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"playlistID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic playlistID;



- (int32_t)playlistIDValue {
	NSNumber *result = [self playlistID];
	return [result intValue];
}

- (void)setPlaylistIDValue:(int32_t)value_ {
	[self setPlaylistID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePlaylistIDValue {
	NSNumber *result = [self primitivePlaylistID];
	return [result intValue];
}

- (void)setPrimitivePlaylistIDValue:(int32_t)value_ {
	[self setPrimitivePlaylistID:[NSNumber numberWithInt:value_]];
}





@dynamic title;






@dynamic audios;

	
- (NSMutableOrderedSet*)audiosSet {
	[self willAccessValueForKey:@"audios"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"audios"];
  
	[self didAccessValueForKey:@"audios"];
	return result;
}
	






@end
