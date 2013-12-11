//
//  MWActivityPresenterSpec.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/4/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "MWActivityPresenter.h"
#import "MWActivityViewController.h"

SpecBegin(MWActivityPresenterSpec)

describe(@"MWActivityPresenter", ^{
    __block MWActivityPresenter *presenter;
    __block MWActivityViewController *activitySheet;
    __block UIViewController *presentingController;

    beforeEach(^{
        activitySheet = mock([MWActivityViewController class]);
        presenter = [[MWActivityPresenter alloc] initWithActivitySheet:activitySheet];
        presentingController = [[UIViewController alloc] init];
        UIApplication.sharedApplication.keyWindow.rootViewController = presentingController;
    });

    describe(@"presenting an activity sheet modally", ^{
        context(@"when there are multiple apps", ^{
            it(@"should be presented on the correct view controller ", ^{
                [given([activitySheet numberOfApplications]) willReturnInteger:2];
                [presenter presentModalActivitySheetFromViewController:presentingController];
                expect(presentingController.presentedViewController).to.equal(activitySheet);
            });
        });

        context(@"when there is only one app", ^{
            it(@"should open it", ^{
                [given([activitySheet numberOfApplications]) willReturnInteger:1];
                [presenter presentModalActivitySheetFromViewController:presentingController];
                [(MWActivityViewController *)verify(activitySheet) performActivityInFirstAvailableApplication];
            });
        });
    });

    describe(@"hiding a modally-presented sheet", ^{
        it(@"should no longer be presented", ^{
            [given([activitySheet numberOfApplications]) willReturnInteger:2];

            [presenter presentModalActivitySheetFromViewController:presentingController];
            expect(presentingController.presentedViewController).to.equal(activitySheet);

            [presenter dismissActivitySheet];
            expect(presentingController.presentedViewController).to.beNil;
        });
    });

});

SpecEnd
