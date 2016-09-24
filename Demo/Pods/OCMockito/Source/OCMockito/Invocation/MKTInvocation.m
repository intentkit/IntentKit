//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTInvocation.h"

#import "MKTLocation.h"


@implementation MKTInvocation

- (instancetype)initWithInvocation:(NSInvocation *)invocation
{
    return [self initWithInvocation:invocation
                           location:[[MKTLocation alloc] init]];
}

- (instancetype)initWithInvocation:(NSInvocation *)invocation location:(MKTLocation *)location
{
    self = [super init];
    if (self) {
        _invocation = invocation;
        _location = location;
    }
    return self;
}

@end
