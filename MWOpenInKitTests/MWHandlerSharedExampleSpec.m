//
//  MWHandlerSharedExampleSpec.m
//  MWOpenInKitTests
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
#import "MWHandler.h"
#import "NSString+Helpers.h"
#import "MWApplicationList.h"
#import "MWActivityPresenter.h"
#import "MWActivityViewController.h"

@interface MWHandler (Spec)
@property UIApplication *application;
@property MWApplicationList *appList;
@end

@interface MWActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;
@end

@interface MWApplicationList (Spec)
@property UIApplication *application;
@end

SharedExamplesBegin(MWHandler)

sharedExamplesFor(@"a handler action", ^(NSDictionary *data) {
    __block MWHandler *handler;
    __block NSString *urlString;
    __block MWActivityPresenter *(^subjectAction)(void);
    __block MWActivityPresenter *presenter;
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
            expect([presenter isKindOfClass:[MWActivityPresenter class]]).to.beTruthy;
        });

        it(@"should have one application", ^{
            expect([presenter.activitySheet numberOfApplications]).to.equal(1);
        });
    });

    context(@"when multiple applications are available", ^{
        beforeEach(^{
            [given([handler.application canOpenURL:anything()]) willReturnBool:YES];
            presenter = subjectAction();
        });

        it(@"should return a valid presenter", ^{
            expect([presenter isKindOfClass:[MWActivityPresenter class]]).to.beTruthy;
        });

        it(@"should have multiple activities", ^{
            expect([presenter.activitySheet numberOfApplications]).to.beGreaterThan(0);
        });
    });
});

sharedExamplesFor(@"an optional handler property", ^(NSDictionary *data) {
    __block MWHandler *handler;
    __block NSString *urlStringWithParam;
    __block MWActivityPresenter *(^subjectAction)(void);

    beforeEach(^{
        handler.application = mock([UIApplication class]);

        handler = data[@"handler"];
        urlStringWithParam = data[@"urlStringWithParam"];
        subjectAction = data[@"subjectAction"];
    });

    it(@"should include the given param", ^{
        [given([handler.application canOpenURL:[NSURL URLWithString:urlStringWithParam.urlScheme]]) willReturnBool:YES];

        MWActivityPresenter *presenter = subjectAction();
        [presenter.activitySheet performActivityInFirstAvailableApplication];

        [(UIApplication *)verify(handler.application) openURL:[NSURL URLWithString:urlStringWithParam]];
    });
});

SharedExamplesEnd