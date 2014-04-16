//
//  INKDefaultsManagerSpec
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/18/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "INKDefaultsManager.h"
#import "INKHandler.h"
#import "INKBrowserHandler.h"

SpecBegin(INKDefaultsManager)

describe(@"INKDefaultsManager", ^{
    __block INKDefaultsManager *manager;

    beforeEach(^{
        manager = [[INKDefaultsManager alloc] init];

        NSString *domainName = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:domainName];
    });

    describe(@"when nothing has been set", ^{
        it(@"should return a handler's default application", ^{
            expect([manager defaultApplicationForHandler:INKBrowserHandler.class allowSystemDefault:YES]).to.equal(@"In App");
        });
    });

    describe(@"setting defaults", ^{
        context(@"when there is no default for an application", ^{
            beforeEach(^{
                [manager addDefault:@"FooBar" forHandler:[INKHandler class]];
            });

            it(@"should be able to retrieve it", ^{
                expect([manager defaultApplicationForHandler:INKHandler.class allowSystemDefault:YES]).to.equal(@"FooBar");
            });

            it(@"should not affect other classes", ^{
                expect([manager defaultApplicationForHandler:INKBrowserHandler.class allowSystemDefault:YES]).toNot.equal(@"FooBar");
            });
        });
    });

    describe(@"clearing out a single default", ^{
        beforeEach(^{
            [manager addDefault:@"Foo" forHandler:[INKHandler class]];
            [manager addDefault:@"Bar" forHandler:[INKBrowserHandler class]];
        });

        it(@"should remove it", ^{
            [manager removeDefaultForHandler:[INKHandler class]];
            expect([manager defaultApplicationForHandler:INKHandler.class allowSystemDefault:NO]).to.beNil();
        });

        it(@"should not remove others", ^{
            [manager removeDefaultForHandler:[INKHandler class]];
            expect([manager defaultApplicationForHandler:INKBrowserHandler.class allowSystemDefault:NO]).to.equal(@"Bar");
        });
    });

    describe(@"removing all defaults", ^{
        beforeEach(^{
            [manager addDefault:@"Foo" forHandler:[INKHandler class]];
            [manager addDefault:@"Bar" forHandler:[INKBrowserHandler class]];
        });

        it(@"should remove all of them", ^{
            [manager removeAllDefaults];
            expect([manager defaultApplicationForHandler:INKHandler.class allowSystemDefault:NO]).to.beNil();
            expect([manager defaultApplicationForHandler:INKBrowserHandler.class allowSystemDefault:YES]).to.equal(@"In App");
        });
    });
    
});

SpecEnd
