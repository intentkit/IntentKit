//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCStringContains.h"


@implementation HCStringContains

- (BOOL)matches:(id)item
{
    if (![item respondsToSelector:@selector(rangeOfString:)])
        return NO;

    return [item rangeOfString:self.substring].location != NSNotFound;
}

- (NSString *)relationship
{
    return @"containing";
}

@end


id <HCMatcher> HC_containsSubstring(NSString *substring)
{
    return [[HCStringContains alloc] initWithSubstring:substring];
}
