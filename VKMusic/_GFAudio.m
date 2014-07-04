// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GFAudio.m instead.

#import "_GFAudio.h"

const struct GFAudioAttributes GFAudioAttributes = {
	.artist = @"artist",
	.audioID = @"audioID",
	.duration = @"duration",
	.progress = @"progress",
	.title = @"title",
	.url = @"url",
};

const struct GFAudioRelationships GFAudioRelationships = {
	.playlist = @"playlist",
};

const struct GFAudioFetchedProperties GFAudioFetchedProperties = {
};

@implementation GFAudioID
@end

@implementation _GFAudio

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Audio" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Audio";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Audio" inManagedObjectContext:moc_];
}

- (GFAudioID*)objectID {
	return (GFAudioID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"audioIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"audioID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"progressValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"progress"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic artist;






@dynamic audioID;



- (int32_t)audioIDValue {
	NSNumber *result = [self audioID];
	return [result intValue];
}

- (void)setAudioIDValue:(int32_t)value_ {
	[self setAudioID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAudioIDValue {
	NSNumber *result = [self primitiveAudioID];
	return [result intValue];
}

- (void)setPrimitiveAudioIDValue:(int32_t)value_ {
	[self setPrimitiveAudioID:[NSNumber numberWithInt:value_]];
}





@dynamic duration;



- (float)durationValue {
	NSNumber *result = [self duration];
	return [result floatValue];
}

- (void)setDurationValue:(float)value_ {
	[self setDuration:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result floatValue];
}

- (void)setPrimitiveDurationValue:(float)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithFloat:value_]];
}





@dynamic progress;



- (float)progressValue {
	NSNumber *result = [self progress];
	return [result floatValue];
}

- (void)setProgressValue:(float)value_ {
	[self setProgress:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveProgressValue {
	NSNumber *result = [self primitiveProgress];
	return [result floatValue];
}

- (void)setPrimitiveProgressValue:(float)value_ {
	[self setPrimitiveProgress:[NSNumber numberWithFloat:value_]];
}





@dynamic title;






@dynamic url;






@dynamic playlist;

	






@end
