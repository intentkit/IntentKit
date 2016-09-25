//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt
//  Contribution by Emile Cantin

#import <Foundation/Foundation.h>
#import "MKTVerificationMode.h"


@interface MKTAtMostTimes : NSObject <MKTVerificationMode>

- (instancetype)initWithMaximumCount:(NSUInteger)maxNumberOfInvocations;

@end
