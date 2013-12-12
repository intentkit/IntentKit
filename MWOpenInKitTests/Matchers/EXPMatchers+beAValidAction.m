//
//  EXPMatchers+beAValidAction.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/11/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "EXPMatchers+beAValidAction.h"
#import <objc/runtime.h>

EXPMatcherImplementationBegin(beAValidAction, (NSString *plistName)) {
    NSArray *whitelist = @[@"openHttpURL:", @"openHttpsURL:"];

    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 ) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
    }

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^MW(.+?)Handler$"
                                                                           options:0
                                                                             error:&error];

    NSMutableArray *methodNames = [NSMutableArray array];
    for (int i = 0; i < numClasses; i++) {
        const char *nameString = class_getName(classes[i]);
        NSString *className = [NSString stringWithUTF8String:nameString];
        if ([regex numberOfMatchesInString:className options:0 range:NSMakeRange(0, className.length)]) {
            unsigned int count;
            Method* methods = class_copyMethodList(classes[i], &count);
            for (int j = 0; j < count; j++) {
                [methodNames addObject:NSStringFromSelector(method_getName(methods[j]))];
            }
            free(methods);
        }
    }
    [methodNames addObjectsFromArray:whitelist];
    free(classes);

    match(^BOOL{
        return [methodNames containsObject:actual];
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"'%@' is not a valid action (defined in %@.plist)", actual, plistName];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"'%@' is a valid action", actual];

    });
}
EXPMatcherImplementationEnd