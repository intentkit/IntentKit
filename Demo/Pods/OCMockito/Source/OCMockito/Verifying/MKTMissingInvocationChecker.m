//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTMissingInvocationChecker.h"

#import "MKTInvocation.h"
#import "MKTInvocationMatcher.h"
#import "MKTLocation.h"
#import "MKTMatchingInvocationsFinder.h"
#import "MKTPrinter.h"


@implementation MKTMissingInvocationChecker

- (NSString *)checkInvocations:(NSArray *)invocations wanted:(MKTInvocationMatcher *)wanted
{
    [self.invocationsFinder findInvocationsInList:invocations matching:wanted];
    NSString *description;
    if (self.invocationsFinder.count == 0)
    {
        MKTInvocation *similar = MKTFindSimilarInvocation(invocations, wanted);
        if (similar)
            description = [self argumentsAreDifferent:similar wanted:wanted];
        else
            description = [self wantedButNotInvoked:wanted otherInvocations:invocations];
    }
    return description;
}

- (NSString *)argumentsAreDifferent:(MKTInvocation *)actual wanted:(MKTInvocationMatcher *)wanted
{
    MKTPrinter *printer = [[MKTPrinter alloc] init];
    NSArray *description = @[
            @"Argument(s) are different!",
            [@"Wanted: " stringByAppendingString:[printer printMatcher:wanted]],
            @"Actual invocation has different arguments:",
            [printer printInvocation:actual],
            [printer printMismatchOf:actual expectation:wanted],
            @"",
            actual.location.description,
    ];
    return [description componentsJoinedByString:@"\n"];
}

- (NSString *)wantedButNotInvoked:(MKTInvocationMatcher *)wanted otherInvocations:(NSArray *)invocations
{
    MKTPrinter *printer = [[MKTPrinter alloc] init];
    NSMutableArray *description = [@[
            @"Wanted but not invoked:",
            [printer printMatcher:wanted],
    ] mutableCopy];

    if (!invocations.count)
        [description addObject:@"Actually, there were zero interactions with this mock."];
    else
        [self reportOtherInvocations:invocations toDescriptionArray:description];

    return [description componentsJoinedByString:@"\n"];
}

- (void)reportOtherInvocations:(NSArray *)invocations
            toDescriptionArray:(NSMutableArray *)description
{
    MKTPrinter *printer = [[MKTPrinter alloc] init];
    [description addObject:@"However, there were other interactions with this mock (✓ means already verified):"];
    for (MKTInvocation *invocation in invocations)
    {
        [description addObject:@""];
        [description addObject:[printer printInvocation:invocation]];
        [description addObject:invocation.location.description];
    }
}

@end


MKTInvocation *MKTFindSimilarInvocation(NSArray *invocations, MKTInvocationMatcher *wanted)
{
    NSUInteger index = [invocations indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        MKTInvocation *inv = obj;
        return !inv.verified && inv.invocation.selector == wanted.expected.selector;
    }];
    return (index == NSNotFound) ? nil : invocations[index];
}
