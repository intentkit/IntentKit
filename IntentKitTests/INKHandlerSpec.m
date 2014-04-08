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
        handler.appList = [[INKApplicationList alloc] initWithApplication:handler.application forHandler:INKHandler.class];
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

    describe(@"defaultApp", ^{
        it(@"should return the current default", ^{
            [given([handler.defaultsManager defaultApplicationForHandler:handler.class allowSystemDefault:NO]) willReturn:@"Flappy Bird"];
            expect([handler defaultApp]).to.equal(@"Flappy Bird");
        });
    });

    describe(@"promptToSetDefault", ^{
        __block INKActivityViewController *controller;
        __block INKActivityPresenter *presenter;

        beforeEach(^{
            presenter = [handler promptToSetDefault];
            controller = presenter.activitySheet;
        });

        it(@"should return a presenter", ^{
            expect(presenter).to.beKindOf([INKActivityPresenter class]);
        });

        it(@"should set an activity view controller on the presenter", ^{
            expect(controller).to.beKindOf([INKActivityViewController class]);
        });

        it(@"should set the delegate", ^{
            expect(controller.delegate).to.equal(handler);
        });

        it(@"should have the appropriate default flag", ^{
            expect(controller.isDefaultSelector).to.beTruthy();
        });

        it(@"should only include available applications", ^{
            expect(controller.numberOfApplications).to.beLessThan(handler.appList.activities.count);
        });
    });

    describe(@"INKActivityViewControllerDefaultsDelegate", ^{
        describe(@"canSetDefault", ^{
            context(@"when there is no default app set", ^{
                it(@"should allow setting", ^{
                    [given([handler.defaultsManager defaultApplicationForHandler:handler.class allowSystemDefault:NO]) willReturn:nil];
                    expect([handler canSetDefault]).to.beTruthy();
                });
            });

            context(@"when there is a default set", ^{
                it(@"should not allow setting", ^{
                    [given([handler.defaultsManager defaultApplicationForHandler:handler.class allowSystemDefault:NO]) willReturn:@"SomeApp"];
                    expect([handler canSetDefault]).toNot.beTruthy();
                });
            });
        });

        describe(@"addDefault:", ^{
            it(@"should add a default", ^{
                INKActivity *activity = [[INKActivity alloc] initWithActions:nil optionalParams:nil name:@"Fart.app" application:nil bundle:nil];
                [handler addDefault:activity];
                [verify(handler.defaultsManager) addDefault:@"Fart.app" forHandler:[INKHandler class]];
            });
        });
    });
});

SpecEnd