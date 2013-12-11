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
            beforeEach(^{
                [given([activitySheet numberOfApplications]) willReturnInteger:2];
                [presenter presentModalActivitySheetFromViewController:presentingController];
            });

            it(@"should be presented on the correct view controller ", ^{
                expect(presentingController.presentedViewController).to.equal(activitySheet);
            });

            context(@"when dismissing it", ^{
                it(@"should no longer be presented", ^{
                    [presenter dismissActivitySheet];
                    expect(presentingController.presentedViewController).to.beNil;
                });
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

    describe(@"presenting an activity sheet in a popover", ^{
        context(@"when positioning by bar button item", ^{
            context(@"when there is only one app", ^{
                it(@"should open it", ^{
                    [given([activitySheet numberOfApplications]) willReturnInteger:1];
                    [presenter presentActivitySheetFromViewController:presentingController popoverFromBarButtonItem:[[UIBarButtonItem alloc] init] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    [(MWActivityViewController *)verify(activitySheet) performActivityInFirstAvailableApplication];
                });
            });

            xcontext(@"when there are multiple apps", ^{
                // TODO: Refactor [MWOpenInKit isPad] so that it can be properly stubbed out for test.
            });
        });

        context(@"when positioning by rect in view", ^{
            context(@"when there is only one app", ^{
                it(@"should open it", ^{
                    [given([activitySheet numberOfApplications]) willReturnInteger:1];
                    [presenter presentActivitySheetFromViewController:presentingController popoverFromRect:CGRectZero inView:presentingController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    [(MWActivityViewController *)verify(activitySheet) performActivityInFirstAvailableApplication];
                });
            });

            xcontext(@"when there are multiple apps", ^{});
        });
    });
});

SpecEnd
