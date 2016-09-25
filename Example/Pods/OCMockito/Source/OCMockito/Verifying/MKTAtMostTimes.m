//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt
//  Contribution by Emile Cantin

#import "MKTAtMostTimes.h"

#import "MKTAtMostNumberOfInvocationsChecker.h"
#import "MKTVerificationData.h"


@interface MKTAtMostTimes ()
@property (nonatomic, assign, readonly) NSUInteger wantedCount;
@end

@implementation MKTAtMostTimes

- (instancetype)initWithMaximumCount:(NSUInteger)maxNumberOfInvocations
{
    self = [super init];
    if (self)
        _wantedCount = maxNumberOfInvocations;
    return self;
}


#pragma mark MKTVerificationMode

- (void)verifyData:(MKTVerificationData *)data testLocation:(MKTTestLocation)testLocation
{
    MKTAtMostNumberOfInvocationsChecker *checker = [[MKTAtMostNumberOfInvocationsChecker alloc] init];
    NSString *failureDescription = [checker checkInvocations:data.invocations
                                                      wanted:data.wanted
                                                 wantedCount:self.wantedCount];
    if (failureDescription)
        MKTFailTestLocation(testLocation, failureDescription);
}

@end
