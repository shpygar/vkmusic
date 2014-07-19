// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GFPlaylist.h instead.

#import <CoreData/CoreData.h>


extern const struct GFPlaylistAttributes {
	__unsafe_unretained NSString *playlistID;
	__unsafe_unretained NSString *title;
} GFPlaylistAttributes;

extern const struct GFPlaylistRelationships {
	__unsafe_unretained NSString *audios;
} GFPlaylistRelationships;

extern const struct GFPlaylistFetchedProperties {
} GFPlaylistFetchedProperties;

@class GFAudio;




@interface GFPlaylistID : NSManagedObjectID {}
@end

@interface _GFPlaylist : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GFPlaylistID*)objectID;





@property (nonatomic, strong) NSNumber* playlistID;



@property int32_t playlistIDValue;
- (int32_t)playlistIDValue;
- (void)setPlaylistIDValue:(int32_t)value_;

//- (BOOL)validatePlaylistID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *audios;

- (NSMutableOrderedSet*)audiosSet;





@end

@interface _GFPlaylist (CoreDataGeneratedAccessors)

- (void)addAudios:(NSOrderedSet*)value_;
- (void)removeAudios:(NSOrderedSet*)value_;
- (void)addAudiosObject:(GFAudio*)value_;
- (void)removeAudiosObject:(GFAudio*)value_;

@end

@interface _GFPlaylist (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitivePlaylistID;
- (void)setPrimitivePlaylistID:(NSNumber*)value;

- (int32_t)primitivePlaylistIDValue;
- (void)setPrimitivePlaylistIDValue:(int32_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (NSMutableOrderedSet*)primitiveAudios;
- (void)setPrimitiveAudios:(NSMutableOrderedSet*)value;


@end
