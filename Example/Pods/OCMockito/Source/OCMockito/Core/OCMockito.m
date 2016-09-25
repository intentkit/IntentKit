//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "OCMockito.h"

#import "MKTAtLeastTimes.h"
#import "MKTAtMostTimes.h"
#import "MKTClassObjectMock.h"
#import "MKTExactTimes.h"
#import "MKTMockitoCore.h"
#import "MKTObjectAndProtocolMock.h"
#import "MKTObjectMock.h"


static BOOL isValidMockClass(id mock)
{
    NSString *className = NSStringFromClass([mock class]);
    return [className isEqualToString:@"MKTObjectMock"] ||
            [className isEqualToString:@"MKTProtocolMock"] ||
            [className isEqualToString:@"MKTClassObjectMock"] ||
            [className isEqualToString:@"MKTObjectAndProtocolMock"];
}

static NSString *actualTypeName(id mock)
{
    NSString *className = NSStringFromClass([mock class]);
    if (!className)
        return @"nil";
    return [@"type " stringByAppendingString:className];
}

static BOOL reportedInvalidMock(id mock, id testCase, const char *fileName, int lineNumber, NSString *functionName)
{
    if (isValidMockClass(mock))
        return NO;
    NSString *description = [NSString stringWithFormat:@"Argument passed to %@ should be a mock but is %@",
                                                       functionName, actualTypeName(mock)];
    MKTFailTest(testCase, fileName, lineNumber, description);
    return YES;
}

id MKTMock(Class classToMock)
{
    return [[MKTObjectMock alloc] initWithClass:classToMock];
}

id MKTMockClass(Class classToMock)
{
    return [[MKTClassObjectMock alloc] initWithClass:classToMock];
}

id MKTMockProtocol(Protocol *protocolToMock)
{
    return [[MKTProtocolMock alloc] initWithProtocol:protocolToMock includeOptionalMethods:YES];
}

id MKTMockProtocolWithoutOptionals(Protocol *protocolToMock)
{
    return [[MKTProtocolMock alloc] initWithProtocol:protocolToMock includeOptionalMethods:NO];
}

id MKTMockObjectAndProtocol(Class classToMock, Protocol *protocolToMock)
{
    return [[MKTObjectAndProtocolMock alloc] initWithClass:classToMock protocol:protocolToMock];
}

MKTOngoingStubbing *MKTGivenWithLocation(id testCase, const char *fileName, int lineNumber, ...)
{
    return [[MKTMockitoCore sharedCore] stubAtLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}

MKTOngoingStubbing *MKTGivenVoidWithLocation(id testCase, const char *fileName, int lineNumber, void(^methodCallWrapper)())
{
    methodCallWrapper();
    return [[MKTMockitoCore sharedCore] stubAtLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}

id MKTVerifyWithLocation(id mock, id testCase, const char *fileName, int lineNumber)
{
    if (reportedInvalidMock(mock, testCase, fileName, lineNumber, @"verify()"))
        return nil;

    return MKTVerifyCountWithLocation(mock, MKTTimes(1), testCase, fileName, lineNumber);
}

id MKTVerifyCountWithLocation(id mock, id mode, id testCase, const char *fileName, int lineNumber)
{
    if (reportedInvalidMock(mock, testCase, fileName, lineNumber, @"verifyCount()"))
        return nil;

    return [[MKTMockitoCore sharedCore] verifyMock:mock
                                          withMode:mode
                                        atLocation:MKTTestLocationMake(testCase, fileName, lineNumber)];
}

id <MKTVerificationMode> MKTTimes(NSUInteger wantedNumberOfInvocations)
{
    return [[MKTExactTimes alloc] initWithCount:wantedNumberOfInvocations];
}

id <MKTVerificationMode> MKTNever()
{
    return MKTTimes(0);
}

id <MKTVerificationMode> MKTAtLeast(NSUInteger minNumberOfInvocations)
{
    return [[MKTAtLeastTimes alloc] initWithMinimumCount:minNumberOfInvocations];
}

id <MKTVerificationMode> MKTAtLeastOnce()
{
    return MKTAtLeast(1);
}

id <MKTVerificationMode> MKTAtMost(NSUInteger maxNumberOfInvocations)
{
    return [[MKTAtMostTimes alloc] initWithMaximumCount:maxNumberOfInvocations];
}

void MKTStopMockingWithLocation(id mock, id testCase, const char *fileName, int lineNumber)
{
    if (reportedInvalidMock(mock, testCase, fileName, lineNumber, @"stopMocking()"))
        return;
    [mock mkt_stopMocking];
}
