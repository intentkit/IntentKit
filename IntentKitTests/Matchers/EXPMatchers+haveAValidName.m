//
//  EXPMatchers+haveAValidName.m
//  IntentKitDemo
//
//  Created by Michael Walker on 12/16/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "EXPMatchers+haveAValidName.h"
#import <objc/runtime.h>

EXPMatcherImplementationBegin(haveAValidName, (NSString *plistName)) {
    match(^BOOL{
        return actual[@"name"] != nil;
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"'%@.plist' is lacking a valid name", plistName];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"'%@.plist' has a valid  name", plistName];

    });
}
EXPMatcherImplementationEnd