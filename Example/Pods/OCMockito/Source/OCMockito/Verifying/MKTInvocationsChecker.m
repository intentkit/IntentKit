#import "MKTNumberOfInvocationsChecker.h"

#import "MKTMatchingInvocationsFinder.h"
#import "MKTLocation.h"


@interface MKTInvocationsChecker ()
@property (nonatomic, copy) NSString *wantedDescription;
@end

@implementation MKTInvocationsChecker

- (instancetype)initWithWantedDescription:(NSString *)wantedDescription
{
    self = [super init];
    if (self)
        self.wantedDescription = [wantedDescription copy];
    return self;
}

- (MKTMatchingInvocationsFinder *)invocationsFinder
{
    if (!_invocationsFinder) {
        _invocationsFinder = [[MKTMatchingInvocationsFinder alloc] init];
    }
    return _invocationsFinder;
}

- (NSString *)tooLittleActual:(NSUInteger)actualCount wantedCount:(NSUInteger)wantedCount
{
    NSString *problem = [self describeWanted:wantedCount butWasCalled:actualCount];
    MKTLocation *location = [self.invocationsFinder locationOfLastInvocation];
    return [self joinProblem:problem location:location locationLabel:@"Last invocation:"];
}

- (NSString *)tooManyActual:(NSUInteger)actualCount wantedCount:(NSUInteger)wantedCount
{
    NSString *problem = [self describeWanted:wantedCount butWasCalled:actualCount];
    MKTLocation *location = [self.invocationsFinder locationOfInvocationAtIndex:wantedCount];
    return [self joinProblem:problem location:location locationLabel:@"Undesired invocation:"];
}

- (NSString *)neverWantedButActual:(NSUInteger)actualCount
{
    NSString *problem = [self describeNeverWantedButWasCalled:actualCount];
    MKTLocation *location = [self.invocationsFinder locationOfInvocationAtIndex:0];
    return [self joinProblem:problem location:location locationLabel:@"Undesired invocation:"];
}

- (NSString *)describeWanted:(NSUInteger)wantedCount butWasCalled:(NSUInteger)actualCount
{
    return [NSString stringWithFormat:@"%@ %@ but was called %@.",
                                      [self wantedDescription],
                                      [self pluralizeTimes:wantedCount],
                                      [self pluralizeTimes:actualCount]];
}

- (NSString *)describeNeverWantedButWasCalled:(NSUInteger)actualCount
{
    return [NSString stringWithFormat:@"Never wanted but was called %@.",
                                      [self pluralizeTimes:actualCount]];
}

- (NSString *)pluralizeTimes:(NSUInteger)count
{
    return count == 1 ? @"1 time" : [NSString stringWithFormat:@"%lu times", (unsigned long)count];
}

- (NSString *)joinProblem:(NSString *)problem
                 location:(MKTLocation *)location
            locationLabel:(NSString *)locationLabel
{
    if (!location)
        return problem;
    else
    {
        NSString *report = [problem stringByAppendingFormat:@" %@\n", locationLabel];
        return [report stringByAppendingString:location.description];
    }
}

@end
