//
//  INKAppPlistLinter.m
//  INKOpenInKitTests
//
//  Created by Michael Walker on 12/11/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "EXPMatchers+beAValidAction.h"
#import "EXPMatchers+haveAValidName.h"
#import "INKApplicationList.h"
#import "INKActivity.h"

SpecBegin(INKAppPlistLinter)

describe(@"INKAppPlistLinter", ^{
    it(@"should only have defined methods", ^{
        INKApplicationList *appList = [[INKApplicationList alloc] init];

        for (INKActivity *app in appList.activities) {
            for (NSString *action in app.actions) {
                expect(action).to.beAValidAction(app.name);
            }
        }
    });

    it(@"should have a name that is either a string or a localized dict", ^{
        NSArray *whitelist = @[@"Info", @"IntentKitBundle-Info"];

        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
        NSBundle *bundle;
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }

        NSArray *appPaths = [bundle pathsForResourcesOfType:@".plist"
                                                inDirectory:nil];
        for (NSString *path in appPaths) {
            NSString *name = [path.pathComponents.lastObject stringByDeletingPathExtension];
            if ([whitelist containsObject:name]) continue;

            if (![path.lastPathComponent hasPrefix:@"INK"]) {
                NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
                expect(dict).to.haveAValidName(name);
            }
        }
    });
});

SpecEnd