//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCSubstringMatcher.h"

#import "HCRequireNonNilObject.h"


@interface HCSubstringMatcher (SubclassResponsibility)
- (NSString *)relationship;
@end


@implementation HCSubstringMatcher

- (instancetype)initWithSubstring:(NSString *)substring
{
    HCRequireNonNilObject(substring);

    self = [super init];
    if (self)
        _substring = [substring copy];
    return self;
}

- (void)describeTo:(id <HCDescription>)description
{
    [[[[description appendText:@"a string "]
                    appendText:[self relationship]]
                    appendText:@" "]
                    appendDescriptionOf:self.substring];
}

@end
