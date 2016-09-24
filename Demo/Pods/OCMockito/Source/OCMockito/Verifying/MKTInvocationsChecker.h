//
// Created by Jon Reid on 11/27/15.
// Copyright (c) 2015 Jonathan M. Reid. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MKTMatchingInvocationsFinder;


@interface MKTInvocationsChecker : NSObject

@property (nonatomic, strong) MKTMatchingInvocationsFinder *invocationsFinder;

- (instancetype)initWithWantedDescription:(NSString *)wantedDescription;
- (NSString *)tooLittleActual:(NSUInteger)actualCount wantedCount:(NSUInteger)wantedCount;
- (NSString *)tooManyActual:(NSUInteger)actualCount wantedCount:(NSUInteger)wantedCount;
- (NSString *)neverWantedButActual:(NSUInteger)actualCount;

@end
