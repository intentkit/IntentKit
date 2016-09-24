//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>

@class MKTInvocationMatcher;
@class MKTLocation;


@interface MKTMatchingInvocationsFinder : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;

- (void)findInvocationsInList:(NSArray *)invocations matching:(MKTInvocationMatcher *)wanted;
- (MKTLocation *)locationOfInvocationAtIndex:(NSUInteger)index;
- (MKTLocation *)locationOfLastInvocation;
- (void)markInvocationsAsVerified;

@end
