//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTFilterCallStack.h"

#import "MKTCallStackElement.h"


static NSUInteger MKTFirstRelevantCallStackIndex(NSArray *parsedStack)
{
    NSUInteger firstIndex = [parsedStack indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        MKTCallStackElement *element = obj;
        return [element.instruction hasPrefix:@"-[MKTBaseMockObject forwardInvocation:]"];
    }];
    return firstIndex + 3;
}

static NSUInteger MKTLastRelevantCallStackIndex(NSArray *parsedStack, NSUInteger startBackFrom, NSString *moduleName)
{
    NSUInteger lastIndex = startBackFrom;
    while (lastIndex > 0 && ![[(parsedStack[lastIndex]) moduleName] isEqualToString:moduleName])
        lastIndex -= 1;
    return [[(parsedStack[lastIndex]) moduleName] isEqualToString:moduleName] ? lastIndex : startBackFrom;
}

NSArray *MKTFilterCallStack(NSArray *parsedStack)
{
    NSUInteger firstIndex = MKTFirstRelevantCallStackIndex(parsedStack);
    NSUInteger lastIndex = MKTLastRelevantCallStackIndex(parsedStack, parsedStack.count - 1, @"XCTest");
    lastIndex = MKTLastRelevantCallStackIndex(parsedStack, lastIndex, [parsedStack[firstIndex] moduleName]);
    return [parsedStack subarrayWithRange:NSMakeRange(firstIndex, lastIndex - firstIndex + 1)];
}
