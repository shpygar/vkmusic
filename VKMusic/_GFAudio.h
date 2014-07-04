// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GFAudio.h instead.

#import <CoreData/CoreData.h>


extern const struct GFAudioAttributes {
	__unsafe_unretained NSString *artist;
	__unsafe_unretained NSString *audioID;
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *progress;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} GFAudioAttributes;

extern const struct GFAudioRelationships {
	__unsafe_unretained NSString *playlist;
} GFAudioRelationships;

extern const struct GFAudioFetchedProperties {
} GFAudioFetchedProperties;

@class GFPlaylist;








@interface GFAudioID : NSManagedObjectID {}
@end

@interface _GFAudio : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GFAudioID*)objectID;





@property (nonatomic, strong) NSString* artist;



//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* audioID;



@property int32_t audioIDValue;
- (int32_t)audioIDValue;
- (void)setAudioIDValue:(int32_t)value_;

//- (BOOL)validateAudioID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* duration;



@property float durationValue;
- (float)durationValue;
- (void)setDurationValue:(float)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* progress;



@property float progressValue;
- (float)progressValue;
- (void)setProgressValue:(float)value_;

//- (BOOL)validateProgress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) GFPlaylist *playlist;

//- (BOOL)validatePlaylist:(id*)value_ error:(NSError**)error_;





@end

@interface _GFAudio (CoreDataGeneratedAccessors)

@end

@interface _GFAudio (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveArtist;
- (void)setPrimitiveArtist:(NSString*)value;




- (NSNumber*)primitiveAudioID;
- (void)setPrimitiveAudioID:(NSNumber*)value;

- (int32_t)primitiveAudioIDValue;
- (void)setPrimitiveAudioIDValue:(int32_t)value_;




- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (float)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(float)value_;




- (NSNumber*)primitiveProgress;
- (void)setPrimitiveProgress:(NSNumber*)value;

- (float)primitiveProgressValue;
- (void)setPrimitiveProgressValue:(float)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (GFPlaylist*)primitivePlaylist;
- (void)setPrimitivePlaylist:(GFPlaylist*)value;


@end
