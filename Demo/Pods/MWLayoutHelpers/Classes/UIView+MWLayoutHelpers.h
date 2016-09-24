#import <UIKit/UIKit.h>

@interface UIView (MWLayoutHelpers)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;

@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat left;
@property (assign, nonatomic) CGFloat right;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

- (CGFloat)bottomOfSuperview;
- (CGFloat)rightOfSuperview;

- (void)moveToPoint:(CGPoint)point;
- (void)moveBy:(CGPoint)pointDelta;
- (void)resizeTo:(CGSize)size;

- (void)setBackgroundBlur;

@end