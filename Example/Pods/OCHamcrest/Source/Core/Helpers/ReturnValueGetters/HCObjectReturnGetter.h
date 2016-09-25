//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCReturnValueGetter.h"


@interface HCObjectReturnGetter : HCReturnValueGetter

- (instancetype)initWithSuccessor:(HCReturnValueGetter *)successor;

@end
