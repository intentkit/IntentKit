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

    beforeEach(^{
        handler.application = mock([UIApplication class]);

        handler = data[@"handler"];
        urlString = data[@"urlString"];
        subjectAction = data[@"subjectAction"];
    });

    context(@"when only one application is available", ^{
        it(@"should open in that application", ^{
            [given([handler.application canOpenURL:[NSURL URLWithString:urlString.urlScheme]]) willReturnBool:YES];

            subjectAction();

            [(UIApplication *)verify(handler.application) openURL:[NSURL URLWithString:urlString]];
        });
    });

    context(@"when multiple apps are installed", ^{
        beforeEach(^{
            [given([handler.application canOpenURL:anything()]) willReturnBool:YES];
        });

        context(@"when a default has not been set", ^{
            it(@"should prompt the user to pick", ^{
                MWActivityPresenter *result = subjectAction();
                expect([result isKindOfClass:[MWActivityPresenter class]]).to.beTruthy;
            });

            it(@"should contain some activities", ^{
                MWActivityPresenter *result = subjectAction();
                NSArray *items = result.activitySheet.applicationActivities;
                expect(items.count).toNot.equal(0);
            });
        });
    });
});

sharedExamplesFor(@"an optional handler property", ^(NSDictionary *data) {
    __block MWHandler *handler;
    __block NSString *urlStringWithParam;
    __block UIActivityViewController *(^subjectAction)(void);

    beforeEach(^{
        handler.application = mock([UIApplication class]);

        handler = data[@"handler"];
        urlStringWithParam = data[@"urlStringWithParam"];
        subjectAction = data[@"subjectAction"];
    });

    it(@"should include the given param", ^{
        [given([handler.application canOpenURL:[NSURL URLWithString:urlStringWithParam.urlScheme]]) willReturnBool:YES];

        subjectAction();

        [(UIApplication *)verify(handler.application) openURL:[NSURL URLWithString:urlStringWithParam]];
    });
});

SharedExamplesEnd