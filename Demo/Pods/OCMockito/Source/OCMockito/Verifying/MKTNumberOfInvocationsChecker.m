//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTNumberOfInvocationsChecker.h"

#import "MKTInvocationMatcher.h"
#import "MKTMatchingInvocationsFinder.h"


@implementation MKTNumberOfInvocationsChecker

- (instancetype)init
{
    self = [super initWithWantedDescription:@"Wanted"];
    return self;
}

- (NSString *)checkInvocations:(NSArray *)invocations
                        wanted:(MKTInvocationMatcher *)wanted
                   wantedCount:(NSUInteger)wantedCount
{
    [self.invocationsFinder findInvocationsInList:invocations matching:wanted];
    NSUInteger actualCount = self.invocationsFinder.count;
    NSString *description;
    if (wantedCount > actualCount)
        description = [self tooLittleActual:actualCount wantedCount:wantedCount];
    else if (wantedCount == 0 && actualCount > 0)
        description = [self neverWantedButActual:actualCount];
    else if (wantedCount < actualCount)
        description = [self tooManyActual:actualCount wantedCount:wantedCount];
    [self.invocationsFinder markInvocationsAsVerified];
    return description;
}

@end
