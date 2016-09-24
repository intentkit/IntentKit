#import "MKTAtMostNumberOfInvocationsChecker.h"

#import "MKTMatchingInvocationsFinder.h"


@implementation MKTAtMostNumberOfInvocationsChecker

- (instancetype)init
{
    self = [super initWithWantedDescription:@"Wanted at most"];
    return self;
}

- (NSString *)checkInvocations:(NSArray *)invocations
                        wanted:(MKTInvocationMatcher *)wanted
                   wantedCount:(NSUInteger)wantedCount
{
    [self.invocationsFinder findInvocationsInList:invocations matching:wanted];
    NSUInteger actualCount = self.invocationsFinder.count;
    NSString *description;
    if (wantedCount == 0 && actualCount > 0)
        description = [self neverWantedButActual:actualCount];
    else if (wantedCount < actualCount)
        description = [self tooManyActual:actualCount wantedCount:wantedCount];
    return description;
}

@end
