//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIsNot.h"

#import "HCWrapInMatcher.h"


@interface HCIsNot ()
@property (nonatomic, strong, readonly) id <HCMatcher> matcher;
@end

@implementation HCIsNot

- (instancetype)initWithMatcher:(id <HCMatcher>)matcher
{
    self = [super init];
    if (self)
        _matcher = matcher;
    return self;
}

- (BOOL)matches:(id)item
{
    return ![self.matcher matches:item];
}

- (void)describeTo:(id <HCDescription>)description
{
    [[description appendText:@"not "] appendDescriptionOf:self.matcher];
}

- (void)describeMismatchOf:(id)item to:(id <HCDescription>)mismatchDescription
{
    [self.matcher describeMismatchOf:item to:mismatchDescription];
}
@end


id HC_isNot(id value)
{
    return [[HCIsNot alloc] initWithMatcher:HCWrapInMatcher(value)];
}
