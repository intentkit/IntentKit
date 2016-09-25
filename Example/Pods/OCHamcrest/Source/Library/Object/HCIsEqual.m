//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCIsEqual.h"


@interface HCIsEqual ()
@property (nonatomic, strong, readonly) id expectedValue;
@end

@implementation HCIsEqual

- (instancetype)initEqualTo:(id)expectedValue
{
    self = [super init];
    if (self)
        _expectedValue = expectedValue;
    return self;
}

- (BOOL)matches:(id)item
{
    if (item == nil)
        return self.expectedValue == nil;
    return [item isEqual:self.expectedValue];
}

- (void)describeTo:(id <HCDescription>)description
{
    if ([self.expectedValue conformsToProtocol:@protocol(HCMatcher)])
    {
        [[[description appendText:@"<"]
                appendDescriptionOf:self.expectedValue]
                       appendText:@">"];
    }
    else
        [description appendDescriptionOf:self.expectedValue];
}

@end


id HC_equalTo(id operand)
{
    return [[HCIsEqual alloc] initEqualTo:operand];
}
