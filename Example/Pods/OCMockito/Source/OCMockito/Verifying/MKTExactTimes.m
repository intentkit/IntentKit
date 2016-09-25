//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTExactTimes.h"

#import "MKTNumberOfInvocationsChecker.h"
#import "MKTVerificationData.h"
#import "MKTMissingInvocationChecker.h"


@interface MKTExactTimes ()
@property (nonatomic, assign, readonly) NSUInteger wantedCount;
@end

@implementation MKTExactTimes

- (instancetype)initWithCount:(NSUInteger)wantedNumberOfInvocations
{
    self = [super init];
    if (self)
        _wantedCount = wantedNumberOfInvocations;
    return self;
}


#pragma mark MKTVerificationMode

- (void)verifyData:(MKTVerificationData *)data testLocation:(MKTTestLocation)testLocation
{
    NSString *failureDescription;
    if (self.wantedCount > 0)
    {
        MKTMissingInvocationChecker *missingInvocation = [[MKTMissingInvocationChecker alloc] init];
        failureDescription = [missingInvocation checkInvocations:data.invocations wanted:data.wanted];
    }
    if (!failureDescription)
    {
        MKTNumberOfInvocationsChecker *numberOfInvocations = [[MKTNumberOfInvocationsChecker alloc] init];
        failureDescription = [numberOfInvocations checkInvocations:data.invocations
                                                            wanted:data.wanted
                                                       wantedCount:self.wantedCount];
    }

    if (failureDescription)
        MKTFailTestLocation(testLocation, failureDescription);
}

@end
