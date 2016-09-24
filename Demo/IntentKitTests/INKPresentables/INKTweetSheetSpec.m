//
//  INKTweetSheetSpec.m
//  IntentKitDemo
//
//  Created by Michael Walker on 4/21/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import <Social/Social.h>
#import "INKTweetSheet.h"
#import "UIViewController+Spec.h"

SpecBegin(INKTweetSheet)

describe(@"INKTweetSheet", ^{
    __block INKTweetSheet *tweetSheet;
    __block UIViewController *rootController;
    beforeEach(^{
        tweetSheet = [INKTweetSheet new];
        rootController = [UIViewController new];
    });

    describe(@"sending email", ^{
        xit(@"should show an INKTweetSheet", ^{ // SLComposeViewController not available in simulator.
            [tweetSheet performAction:@"tweetMessage:" params:@{} inViewController:rootController];
            expect(rootController.presentedViewController).to.beInstanceOf(SLComposeViewController.class);
        });
    });
});

SpecEnd