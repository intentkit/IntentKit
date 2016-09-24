//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIsInstanceOf.h"


@implementation HCIsInstanceOf

- (BOOL)matches:(id)item
{
    return [item isKindOfClass:self.theClass];
}

- (NSString *)expectation
{
    return @"an instance of ";
}

@end


id HC_instanceOf(Class expectedClass)
{
    return [[HCIsInstanceOf alloc] initWithClass:expectedClass];
}
