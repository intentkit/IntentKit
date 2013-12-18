//
//  INKHandlerSharedExampleSpec.m
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
#import "NSString+Helpers.h"
#import "INKApplicationList.h"
#import "INKActivityPresenter.h"
#import "INKActivityViewController.h"
#import "INKActivity.h"

@interface INKHandler (Spec)
@property UIApplication *application;
@property INKApplicationList *appList;
@end

@interface INKActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;
@end

@interface INKApplicationList (Spec)
@property UIApplication *application;
@end

SharedExamplesBegin(INKHandler)

sharedExamplesFor(@"a handler action", ^(NSDictionary *data) {
    __block INKHandler *handler;
    __block NSString *urlString;
    __block INKActivityPresenter *(^subjectAction)(void);
    __block INKActivityPresenter *presenter;
    beforeEach(^{
        handler.application = mock([UIApplication class]);

        handler = data[@"handler"];
        urlString = data[@"urlString"];
        subjectAction = data[@"subjectAction"];
    });

    context(@"when only one application is available", ^{
        beforeEach(^{
            [given([handler.application canOpenURL:[NSURL URLWithString:urlString.urlScheme]]) willReturnBool:YES];
            presenter = subjectAction();
        });

        it(@"should return a valid presenter", ^{
            expect([presenter isKindOfClass:[INKActivityPresenter class]]).to.beTruthy;
        });

        it(@"should not have a view controller", ^{
            expect(presenter.activitySheet).to.beNil();
        });

        it(@"should have an activity", ^{
            expect(presenter.activity).to.beKindOf([INKActivity class]);
        });
    });

    context(@"when multiple applications are available", ^{
        beforeEach(^{
            [given([handler.application canOpenURL:anything()]) willReturnBool:YES];
            presenter = subjectAction();
        });

        it(@"should return a valid presenter", ^{
            expect([presenter isKindOfClass:[INKActivityPresenter class]]).to.beTruthy;
        });

        it(@"should have multiple activities", ^{
            expect([presenter.activitySheet numberOfApplications]).to.beGreaterThan(0);
        });

        it(@"should not have an activity", ^{
            expect(presenter.activity).to.beNil();
        });

    });
});

sharedExamplesFor(@"an optional handler property", ^(NSDictionary *data) {
    __block INKHandler *handler;
    __block NSString *urlStringWithParam;
    __block INKActivityPresenter *(^subjectAction)(void);

    beforeEach(^{
        handler.application = mock([UIApplication class]);

        handler = data[@"handler"];
        urlStringWithParam = data[@"urlStringWithParam"];
        subjectAction = data[@"subjectAction"];
    });

    it(@"should include the given param", ^{
        [given([handler.application canOpenURL:[NSURL URLWithString:urlStringWithParam.urlScheme]]) willReturnBool:YES];

        INKActivityPresenter *presenter = subjectAction();
        [presenter presentModalActivitySheetFromViewController:nil];

        [(UIApplication *)verify(handler.application) openURL:[NSURL URLWithString:urlStringWithParam]];
    });
});

SharedExamplesEnd