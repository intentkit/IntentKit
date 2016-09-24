//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIsEmptyCollection.h"

#import "HCIsEqual.h"


@implementation HCIsEmptyCollection

- (instancetype)init
{
    self = [super initWithMatcher:HC_equalTo(@0)];
    return self;
}

- (void)describeMismatchOf:(id)item to:(id <HCDescription>)mismatchDescription
{
    [[mismatchDescription appendText:@"was "] appendDescriptionOf:item];
}

- (void)describeTo:(id <HCDescription>)description
{
    [description appendText:@"empty collection"];
}

@end


FOUNDATION_EXPORT id HC_isEmpty()
{
    return [[HCIsEmptyCollection alloc] init];
}
