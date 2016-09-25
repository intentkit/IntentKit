//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIsTypeOf.h"


@implementation HCIsTypeOf

- (BOOL)matches:(id)item
{
    return [item isMemberOfClass:self.theClass];
}

- (NSString *)expectation
{
    return @"an exact instance of ";
}

@end


id HC_isA(Class expectedClass)
{
    return [[HCIsTypeOf alloc] initWithClass:expectedClass];
}
