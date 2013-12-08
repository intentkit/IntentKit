//
//  MWWebBrowserSpec.m
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
#import "MWBrowserHandler.h"

@interface MWBrowserHandler (Spec)
@property UIApplication *application;
@end

@interface UIActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;

@end

SpecBegin(MWWebBrowser)

describe(@"MWWebBrowser", ^{
    __block MWBrowserHandler *webBrowser;

    beforeEach(^{
        webBrowser = [[MWBrowserHandler alloc] init];
        webBrowser.application = mock([UIApplication class]);
    });

    describe(@"Opening a http URL", ^{
        itShouldBehaveLike(@"a handler action", ^{
            NSString *urlString = @"http://google.com";
            return @{@"handler":  webBrowser,
                     @"urlString": urlString,
                     @"subjectAction": [^{
                         return [webBrowser openURL:[NSURL URLWithString:urlString]];
                     } copy]};
        });
    });

    describe(@"Opening a https URL", ^{
        itShouldBehaveLike(@"a handler action", ^{
            NSString *urlString = @"http://google.com";
            return @{@"handler":  webBrowser,
                     @"urlString": urlString,
                     @"subjectAction": [^{
                         return [webBrowser openURL:[NSURL URLWithString:urlString]];
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
                [given([webBrowser.application canOpenURL:anything()]) willReturnBool:YES];

                [webBrowser openURL:url withCallback:callbackURL];

                NSString *expected = @"googlechrome-x-callback://x-callback-url/open/?x-source=MWOpenInKitDemo&x-success=testapp%3A%2F%2Ftest&url=http%3A%2F%2Fgoogle.com";
                NSURL *expectedURL = [NSURL URLWithString:expected];
                [(UIApplication *)verify(webBrowser.application) openURL:expectedURL];
            });
        });
    });
});

SpecEnd