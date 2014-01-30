#import <UIKit/UIKit.h>

@interface UIView (Helpers)

- (CGFloat) top;
- (CGFloat) bottom;
- (CGFloat) left;
- (CGFloat) right;

- (CGFloat) width;
- (CGFloat) height;

- (CGSize) size;
- (CGPoint) origin;

- (CGFloat)bottomOfSuperview;
- (CGFloat)rightOfSuperview;

- (void)moveToPoint:(CGPoint)point;
- (void)moveBy:(CGPoint)pointDelta;
- (void)resizeTo:(CGSize)size;

- (void)setBackgroundBlur;

@end