#import <UIKit/UIKit.h>

typedef enum {
    ViewCornerTopLeft,
    ViewCornerBottomLeft,
    ViewCornerTopRight,
    ViewCornerBottomRight
} ViewCorner;

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

//-------------------------
// PivotalCoreKit code here
//-------------------------

// Intended for the idiom view.center = superview.centerBounds;
- (CGPoint)centerBounds;

// Move/resize as separate operations, working off of all four corners
- (void)moveCorner:(ViewCorner)corner toPoint:(CGPoint)point;
- (void)moveToPoint:(CGPoint)point;
- (void)moveBy:(CGPoint)pointDelta;
- (void)resizeTo:(CGSize)size keepingCorner:(ViewCorner)corner;
- (void)resizeTo:(CGSize)size;

@end