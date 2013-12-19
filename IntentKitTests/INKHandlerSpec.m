//
//  INKHandlerSpec.m
//  INKOpenInKitTests
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "INKHandler.h"
#import "INKActivity.h"
#import "INKApplicationList.h"
#import "INKDefaultsManager.h"
#import "INKActivityPresenter.h"

@interface INKHandler (Spec)
@property UIApplication *application;
@property INKApplicationList *appList;
@property INKDefaultsManager *defaultsManager;
@end

SpecBegin(INKHandler)

describe(@"INKHandler", ^{
    __block INKHandler *handler;

    beforeEach(^{
        handler = [[INKHandler alloc] init];
        handler.application = mock([UIApplication class]);
        handler.appList = [[INKApplicationList alloc] initWithApplication:handler.application];
        handler.defaultsManager = mock([INKDefaultsManager class]);
    });

    it(@"should initialize its external dependencies", ^{
        handler = [[INKHandler alloc] init];
        expect(handler.application).to.equal(UIApplication.sharedApplication);
        expect(handler.appList).to.beInstanceOf([INKApplicationList class]);
        expect(handler.defaultsManager).to.beInstanceOf([INKDefaultsManager class]);
    });

    describe(@"canPerformCommand:", ^{
        context(@"when there are appropriate apps installed", ^{
            it(@"should return YES", ^{
                INKActivity *noActivity = mock([INKActivity class]);
                [given([noActivity canPerformCommand:@"doSomething"]) willReturnBool:NO];
                INKActivity *yesActivity = mock([INKActivity class]);
                [given([yesActivity canPerformCommand:@"doSomething"]) willReturnBool:YES];

                handler.appList = mock([INKApplicationList class]);
                [given([handler.appList activities]) willReturn:@[noActivity, yesActivity]];

                expect([handler canPerformCommand:@"doSomething"]).to.beTruthy();
            });
        });
        context(@"when there are no appropriate apps installed", ^{
            it(@"should return NO", ^{
                INKActivity *activity = mock([INKActivity class]);
                [given([activity canPerformCommand:@"doSomething"]) willReturnBool:NO];

                handler.appList = mock([INKApplicationList class]);
                [given([handler.appList activities]) willReturn:@[activity]];

                expect([handler canPerformCommand:@"doSomething"]).toNot.beTruthy();
            });
        });
    });

    describe(@"INKActivityViewControllerDefaultsDelegate", ^{
        describe(@"canSetDefault", ^{
            context(@"when there is no default app set", ^{
                it(@"should allow setting", ^{
                    [given([handler.defaultsManager defaultApplicationForHandler:handler.class]) willReturn:nil];
                    expect([handler canSetDefault]).to.beTruthy();
                });
            });

            context(@"when there is a default set", ^{
                it(@"should not allow setting", ^{
                    [given([handler.defaultsManager defaultApplicationForHandler:handler.class]) willReturn:@"SomeApp"];
                    expect([handler canSetDefault]).toNot.beTruthy();
                });
            });
        });

        describe(@"addDefault:", ^{
            it(@"should add a default", ^{
                INKActivity *activity = [[INKActivity alloc] initWithActions:nil optionalParams:nil name:@"Fart.app" application:nil];
                [handler addDefault:activity];
                [verify(handler.defaultsManager) addDefault:@"Fart.app" forHandler:[INKHandler class]];
            });
        });
    });
});

SpecEnd