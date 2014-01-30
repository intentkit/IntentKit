#import "UIView+Helpers.h"

@implementation UIView (Helpers)

#pragma mark - Accessors
- (CGFloat)top {
    return self.frame.origin.y;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)bottomOfSuperview {
    return self.superview.bottom - self.frame.size.height;
}

- (CGFloat)rightOfSuperview {
    return self.superview.right - self.frame.size.width;
}


#pragma mark - Frame layout
- (void)moveToPoint:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)moveBy:(CGPoint)pointDelta {
    CGRect frame = self.frame;
    frame.origin = CGPointMake(self.left + pointDelta.x,
                               self.top + pointDelta.y);
    self.frame = frame;
}

- (void)resizeTo:(CGSize)size {
    self.frame = CGRectMake(self.left,
                            self.top,
                            size.width,
                            size.height);
}

# pragma mark - Other
- (void)setBackgroundBlur {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    toolbar.translucent = YES;
    toolbar.clipsToBounds = YES;
    self.opaque = NO;
    [self addSubview:toolbar];
}


@end