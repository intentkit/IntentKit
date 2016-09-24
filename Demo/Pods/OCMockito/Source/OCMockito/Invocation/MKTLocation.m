//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTLocation.h"

#import "MKTFilterCallStack.h"
#import "MKTParseCallStack.h"


@interface MKTLocation ()
@property (nonatomic, copy, readonly) NSArray *callStack;
@end

@implementation MKTLocation

- (instancetype)init
{
    self = [self initWithCallStack:[NSThread callStackSymbols]];
    return self;
}

- (instancetype)initWithCallStack:(NSArray *)callStack
{
    self = [super init];
    if (self)
        _callStack = [callStack copy];
    return self;
}

- (NSString *)description
{
    NSArray *stack = MKTFilterCallStack(MKTParseCallStack(self.callStack));
    return [stack componentsJoinedByString:@"\n"];
}

@end
