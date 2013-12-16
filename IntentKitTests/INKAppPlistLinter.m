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
#import "INKApplicationList.h"
#import "INKActivity.h"

SpecBegin(INKAppPlistLinter)

describe(@"INKAppPlistLinter", ^{
    it(@"should only have defined methods", ^{
        INKApplicationList *appList = [[INKApplicationList alloc] init];

        for (INKActivity *app in appList.activities) {
            for (NSString *action in app.actions) {
                if ([action isEqualToString:@"optional"]) { continue; }
                expect(action).to.beAValidAction(app.name);
            }
        }
    });
});

SpecEnd