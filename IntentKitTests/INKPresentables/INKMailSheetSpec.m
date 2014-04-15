//
//  INKMailSheetSpec.m
//  IntentKitDemo
//
//  Created by Michael Walker on 4/15/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import <MessageUI/MessageUI.h>
#import "INKMailSheet.h"
#import "UIViewController+Spec.h"

SpecBegin(INKMailSheet)

describe(@"INKMailSheet", ^{
    __block INKMailSheet *mailSheet;
    __block UIViewController *rootController;
    beforeEach(^{
        mailSheet = [INKMailSheet new];
        rootController = [UIViewController new];
    });

    describe(@"sending email", ^{
        it(@"should show a MFMailComposeViewController", ^{
            [mailSheet performAction:@"sendMailTo:" params:@{} inViewController:rootController];
            expect(rootController.presentedViewController).to.beInstanceOf(MFMailComposeViewController.class);
        });

        xit(@"should pass along parameters", ^{
            // There doesn't appear to be a way to get the current recipient/etc out of the mail controller. Finding an alternate way to spy on the object/replace it with a fake feels like overkill.
        });
    });
});

SpecEnd