//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTVerificationData.h"

#import "MKTInvocationContainer.h"


@interface MKTVerificationData ()
@property (nonatomic, strong, readonly) MKTInvocationContainer *invocationContainer;
@end


@implementation MKTVerificationData

@dynamic invocations;

- (instancetype)initWithInvocationContainer:(MKTInvocationContainer *)invocationContainer
                          invocationMatcher:(MKTInvocationMatcher *)wanted;
{
    self = [super init];
    if (self)
    {
        _invocationContainer = invocationContainer;
        _wanted = wanted;
    }
    return self;
}

- (NSArray *)invocations
{
    return self.invocationContainer.registeredInvocations;
}

@end
