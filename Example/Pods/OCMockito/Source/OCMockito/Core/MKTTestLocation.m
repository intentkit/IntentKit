//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTTestLocation.h"

#import <OCHamcrest/HCTestFailure.h>
#import <OCHamcrest/HCTestFailureReporter.h>
#import <OCHamcrest/HCTestFailureReporterChain.h>

void MKTFailTest(id testCase, const char *fileName, int lineNumber, NSString *description)
{
    HCTestFailure *failure = [[HCTestFailure alloc] initWithTestCase:testCase
                                                            fileName:[NSString stringWithUTF8String:fileName]
                                                          lineNumber:(NSUInteger)lineNumber
                                                              reason:description];
    HCTestFailureReporter *failureReporter = [HCTestFailureReporterChain reporterChain];
    [failureReporter handleFailure:failure];
}

void MKTFailTestLocation(MKTTestLocation testLocation, NSString *description)
{
    MKTFailTest(testLocation.testCase, testLocation.fileName, testLocation.lineNumber, description);
}
