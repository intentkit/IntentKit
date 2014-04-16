//
//  INKActivityPresenterSpec.m
//  INKOpenInKitDemo
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
#import "INKActivityPresenter.h"
#import "INKActivityViewController.h"
#import "INKActivity.h"

@interface INKActivityPresenter ()
@property NSUserDefaults *userDefaults;
@end

SpecBegin(INKActivityPresenterSpec)

describe(@"INKActivityPresenter", ^{
    __block INKActivityPresenter *presenter;
    __block INKActivity *activity;
    __block INKActivityViewController *activitySheet;
    __block UIViewController *presentingController;

    context(@"when there is an activity", ^{
        beforeEach(^{
            activity = mock([INKActivity class]);
            presentingController = [UIViewController new];
            presenter = [[INKActivityPresenter alloc] initWithActivity:activity];
        });

        describe(@"#presentModalActivitySheetFromViewController:", ^{
            it(@"should perform the action", ^{
                [presenter presentModalActivitySheetFromViewController:presentingController completion:nil];
                [(INKActivity *)verify(activity) performActivityInViewController:presentingController];
            });
        });

        describe(@"presentActivitySheetFromViewController:popoverFromRect:inView:", ^{
            it(@"should perform the action", ^{
                [presenter presentActivitySheetFromViewController:presentingController popoverFromRect:CGRectZero inView:nil permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES completion:nil];
                [(INKActivity *)verify(activity) performActivityInViewController:presentingController];
            });

        });

        describe(@"presentActivitySheetFromViewController:barButtonItem:", ^{
            it(@"should perform the action", ^{
                [presenter presentActivitySheetFromViewController:presentingController popoverFromBarButtonItem:nil permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES completion:nil];
                [(INKActivity *)verify(activity) performActivityInViewController:presentingController];
            });

        });

    });

    context(@"when there is an activity view controller", ^{
        beforeEach(^{
            activitySheet = mock([INKActivityViewController class]);
            presenter = [[INKActivityPresenter alloc] initWithActivitySheet:activitySheet];
            presentingController = [[UIViewController alloc] init];
            UIApplication.sharedApplication.keyWindow.rootViewController = presentingController;
        });

        describe(@"presenting an activity sheet modally", ^{
            context(@"when there are multiple apps", ^{
                beforeEach(^{
                    [given([activitySheet numberOfApplications]) willReturnInteger:2];
                    [presenter presentModalActivitySheetFromViewController:presentingController completion:nil];
                });

                it(@"should be presented on the correct view controller ", ^{
                    expect(presentingController.presentedViewController).to.equal(activitySheet);
                });

                context(@"when dismissing it", ^{
                    it(@"should no longer be presented", ^{
                        [presenter dismissActivitySheetAnimated:YES];
                        expect(presentingController.presentedViewController).to.beNil;
                    });
                });
            });
        });

        describe(@"presenting an activity sheet in a popover", ^{
            context(@"when positioning by bar button item", ^{
                xcontext(@"when there are multiple apps", ^{
                    // TODO: Refactor [IntentKit isPad] so that it can be properly stubbed out for test.
                });
            });

            context(@"when positioning by rect in view", ^{
                xcontext(@"when there are multiple apps", ^{});
            });
        });
        
    });
});

SpecEnd
