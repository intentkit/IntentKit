//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIsCloseTo.h"


@interface HCIsCloseTo ()
@property (nonatomic, assign, readonly) double value;
@property (nonatomic, assign, readonly) double delta;
@end

@implementation HCIsCloseTo

- (id)initWithValue:(double)value delta:(double)delta
{
    self = [super init];
    if (self)
    {
        _value = value;
        _delta = delta;
    }
    return self;
}

- (BOOL)matches:(id)item
{
    if ([self itemIsNotNumber:item])
        return NO;

    return [self actualDelta:item] <= self.delta;
}

- (double)actualDelta:(id)item
{
    return fabs([item doubleValue] - self.value);
}

- (BOOL)itemIsNotNumber:(id)item
{
    return ![item isKindOfClass:[NSNumber class]];
}

- (void)describeMismatchOf:(id)item to:(id <HCDescription>)mismatchDescription
{
    if ([self itemIsNotNumber:item])
        [super describeMismatchOf:item to:mismatchDescription];
    else
    {
        [[[mismatchDescription appendDescriptionOf:item]
                               appendText:@" differed by "]
                               appendDescriptionOf:@([self actualDelta:item])];
    }
}

- (void)describeTo:(id <HCDescription>)description
{
    [[[[description appendText:@"a numeric value within "]
                    appendDescriptionOf:@(self.delta)]
                    appendText:@" of "]
                    appendDescriptionOf:@(self.value)];
}

@end


id HC_closeTo(double value, double delta)
{
    return [[HCIsCloseTo alloc] initWithValue:value delta:delta];
}
