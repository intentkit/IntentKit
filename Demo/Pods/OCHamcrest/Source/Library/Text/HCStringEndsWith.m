//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCStringEndsWith.h"


@implementation HCStringEndsWith

- (BOOL)matches:(id)item
{
    if (![item respondsToSelector:@selector(hasSuffix:)])
        return NO;

    return [item hasSuffix:self.substring];
}

- (NSString *)relationship
{
    return @"ending with";
}

@end


id HC_endsWith(NSString *suffix)
{
    return [[HCStringEndsWith alloc] initWithSubstring:suffix];
}
