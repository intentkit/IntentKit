//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIs.h"

#import "HCWrapInMatcher.h"


@interface HCIs ()
@property (nonatomic, strong, readonly) id <HCMatcher> matcher;
@end

@implementation HCIs

- (instancetype)initWithMatcher:(id <HCMatcher>)matcher
{
    self = [super init];
    if (self)
        _matcher = matcher;
    return self;
}

- (BOOL)matches:(id)item
{
    return [self.matcher matches:item];
}

- (void)describeMismatchOf:(id)item to:(id <HCDescription>)mismatchDescription
{
    [self.matcher describeMismatchOf:item to:mismatchDescription];
}

- (void)describeTo:(id <HCDescription>)description
{
    [description appendDescriptionOf:self.matcher];
}

@end


id HC_is(id value)
{
    return [[HCIs alloc] initWithMatcher:HCWrapInMatcher(value)];
}
