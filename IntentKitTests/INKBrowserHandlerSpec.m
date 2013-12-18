//
//  INKBrowserHandlerSpec.m
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
#import "INKBrowserHandler.h"
#import "INKApplicationList.h"
#import "INKActivityPresenter.h"
#import "INKActivityViewController.h"

@interface INKBrowserHandler (Spec)
@property UIApplication *application;
@property INKApplicationList *appList;
@end

SpecBegin(INKBrowserHandler)

describe(@"INKBrowserHandler", ^{
    __block INKBrowserHandler *handler;

    beforeEach(^{
        handler = [[INKBrowserHandler alloc] init];
        handler.application = mock([UIApplication class]);
        handler.appList = [[INKApplicationList alloc] initWithApplication:handler.application];
    });

    describe(@"Opening a http URL", ^{
        itShouldBehaveLike(@"a handler action", ^{
            NSString *urlString = @"http://google.com";
            return @{@"handler":  handler,
                     @"appName": @"Safari",
                     @"urlString": urlString,
                     @"subjectAction": [^{
                         return [handler openURL:[NSURL URLWithString:urlString]];
                     } copy]};
        });
    });

    describe(@"Opening a https URL", ^{
        itShouldBehaveLike(@"a handler action", ^{
            NSString *urlString = @"http://google.com";
            return @{@"handler":  handler,
                     @"appName": @"Safari",
                     @"urlString": urlString,
                     @"subjectAction": [^{
                         return [handler openURL:[NSURL URLWithString:urlString]];
                     } copy]};
        });
    });

    describe(@"Opening a callback", ^{
        __block NSURL *url;
        __block NSURL *callbackURL;

        beforeEach(^{
            url = [NSURL URLWithString:@"http://google.com"];
            callbackURL = [NSURL URLWithString:@"testapp://test"];
        });

        context(@"when Chrome is installed", ^{
            it(@"should open the URL in Chrome via callback", ^{
                [given([handler.application canOpenURL:anything()]) willReturnBool:YES];

                INKActivityPresenter *presenter = [handler openURL:url withCallback:callbackURL];
                [presenter presentModalActivitySheetFromViewController:nil];

                NSString *expected = @"googlechrome-x-callback://x-callback-url/open/?x-source=IntentKitDemo&x-success=testapp%3A%2F%2Ftest&url=http%3A%2F%2Fgoogle.com";
                NSURL *expectedURL = [NSURL URLWithString:expected];
                [(UIApplication *)verify(handler.application) openURL:expectedURL];
            });
        });
    });
});

SpecEnd