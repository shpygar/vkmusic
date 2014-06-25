#import <UIKit/UIKit.h>

@protocol GFSeekSliderDelegate <NSObject>
@optional

-(void) changeY:(NSNumber*) value;

@end

@interface GFSeekSlider : UISlider

@property (nonatomic, weak) id<GFSeekSliderDelegate> delegate;

@end