//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>

@class MKTLocation;


@interface MKTInvocation : NSObject

@property (nonatomic, strong, readonly) NSInvocation *invocation;
@property (nonatomic, strong, readonly) MKTLocation *location;
@property (nonatomic, assign) BOOL verified;

- (instancetype)initWithInvocation:(NSInvocation *)invocation;
- (instancetype)initWithInvocation:(NSInvocation *)invocation location:(MKTLocation *)location;

@end
