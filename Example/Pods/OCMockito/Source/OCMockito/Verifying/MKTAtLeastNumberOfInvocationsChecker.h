//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTInvocationsChecker.h"

@class MKTInvocationMatcher;


@interface MKTAtLeastNumberOfInvocationsChecker : MKTInvocationsChecker

- (NSString *)checkInvocations:(NSArray *)invocations
                        wanted:(MKTInvocationMatcher *)wanted
                   wantedCount:(NSUInteger)wantedCount;

@end
