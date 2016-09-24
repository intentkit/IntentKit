//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>

#import "MKTTestLocation.h"

@class MKTInvocationContainer;
@class MKTInvocationMatcher;


@interface MKTVerificationData : NSObject

@property (nonatomic, copy, readonly) NSArray *invocations;
@property (nonatomic, strong, readonly) MKTInvocationMatcher *wanted;

- (instancetype)initWithInvocationContainer:(MKTInvocationContainer *)invocationContainer
                          invocationMatcher:(MKTInvocationMatcher *)wanted;

@end
