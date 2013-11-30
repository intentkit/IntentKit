#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "OKBrowserHandler.h"

@interface OKBrowserHandler (Spec)
@property UIApplication *application;
@end

@interface UIActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;

@end

SpecBegin(OKWebBrowser)

describe(@"OKWebBrowser", ^{
    __block OKBrowserHandler *webBrowser;

    beforeEach(^{
        webBrowser = [[OKBrowserHandler alloc] init];
        webBrowser.application = mock([UIApplication class]);
    });

    describe(@"Opening a http URL", ^{
        itShouldBehaveLike(@"a handler action", ^{
            NSString *urlString = @"http://google.com";
            return @{@"handler":  webBrowser,
                     @"urlString": urlString,
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         [webBrowser openURL:[NSURL URLWithString:urlString]];
                     } copy]};
        });
    });

    describe(@"Opening a https URL", ^{
        itShouldBehaveLike(@"a handler action", ^{
            NSString *urlString = @"http://google.com";
            return @{@"handler":  webBrowser,
                     @"urlString": urlString,
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         [webBrowser openURL:[NSURL URLWithString:urlString]];
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

                NSString *expected = @"googlechrome-x-callback://x-callback-url/open/?x-source=OpenInKitExample&x-success=testapp%3A%2F%2Ftest&url=http%3A%2F%2Fgoogle.com";
                NSURL *expectedURL = [NSURL URLWithString:expected];
                [(UIApplication *)verify(webBrowser.application) openURL:expectedURL];
            });
        });
    });
});

SpecEnd