//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTInvocationsChecker.h"

@class MKTInvocation;
@class MKTInvocationMatcher;


@interface MKTMissingInvocationChecker : MKTInvocationsChecker

- (NSString *)checkInvocations:(NSArray *)invocations wanted:(MKTInvocationMatcher *)wanted;

@end


MKTInvocation *MKTFindSimilarInvocation(NSArray *invocations, MKTInvocationMatcher *wanted);
