//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTMatchingInvocationsFinder.h"

#import "MKTInvocation.h"
#import "MKTInvocationMatcher.h"


@interface MKTMatchingInvocationsFinder ()
@property (nonatomic, copy) NSArray *invocations;
@end

@implementation MKTMatchingInvocationsFinder

@dynamic count;

- (void)findInvocationsInList:(NSArray *)invocations matching:(MKTInvocationMatcher *)wanted
{
    self.invocations = [invocations filteredArrayUsingPredicate:
            [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
                MKTInvocation *invocation = obj;
                return !invocation.verified && [wanted matches:invocation.invocation];
            }]];
}

- (NSUInteger)count
{
    return self.invocations.count;
}

- (MKTLocation *)locationOfInvocationAtIndex:(NSUInteger)index
{
    MKTInvocation *invocation = self.invocations[index];
    return invocation.location;
}

- (MKTLocation *)locationOfLastInvocation
{
    MKTInvocation *invocation = self.invocations.lastObject;
    return invocation.location;
}

- (void)markInvocationsAsVerified
{
    for (MKTInvocation *invocation in self.invocations)
        invocation.verified = YES;
}

@end
