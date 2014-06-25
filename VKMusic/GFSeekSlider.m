#import "GFSeekSlider.h"

/*
 * A UISlider that increases the area to grab the ball and also slides
 * the ball to wherever on the bar you put your finger.
 */
@implementation GFSeekSlider
/*
 Custom views should implement all touch handlers, even if it's a null implementation, and should not call super.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(changeY:)]) {
        UITouch *theTouch = [touches anyObject];
        CGPoint tapPoint = [theTouch locationInView:self];
        [self.delegate changeY:[NSNumber numberWithDouble:tapPoint.y]];
    }
}

@end