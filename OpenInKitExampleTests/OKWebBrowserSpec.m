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
        __block NSURL *url;
        beforeEach(^{
            url = [NSURL URLWithString:@"http://google.com"];
        });

        context(@"when only Mobile Safari is installed", ^{
            it(@"should open in Mobile Safari", ^{
                [given([webBrowser.application canOpenURL:[NSURL URLWithString:@"googlechrome://google.com"]]) willReturnBool:NO];
                [given([webBrowser.application canOpenURL:[NSURL URLWithString:@"http://google.com"]]) willReturnBool:YES];

                [webBrowser openURL:url];
                [(UIApplication *)verify(webBrowser.application) openURL:url];
            });
        });

        context(@"when multiple browsers are installed", ^{
            beforeEach(^{
                [given([webBrowser.application canOpenURL:anything()]) willReturnBool:YES];
            });

            context(@"when a default has not been set", ^{
                it(@"should prompt the user to pick", ^{
                    [webBrowser openURL:url];

                    UIViewController *presented = UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    expect(presented).will.beKindOf([UIActivityViewController class]);
                });

                it(@"should contain the correct activities", ^{
                    [webBrowser openURL:url];

                    UIActivityViewController *presented = (UIActivityViewController *)UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    NSArray *items = [presented applicationActivities];
                    expect(items.count).to.equal(2);
                });
            });

            xcontext(@"when a default has been set", ^{
                it(@"should use the default", ^{
                    // set default to Chrome

                    //[(UIApplication *)verify(app) openURL:[NSURL URLWithString:@"googlechrome://google.com"]];
                });
            });
        });
    });

    describe(@"Opening a https URL", ^{
        __block NSURL *url;
        beforeEach(^{
            url = [NSURL URLWithString:@"https://google.com"];
        });

        context(@"when only Mobile Safari is installed", ^{
            it(@"should open in Mobile Safari", ^{
                [given([webBrowser.application canOpenURL:[NSURL URLWithString:@"googlechromes://google.com"]]) willReturnBool:NO];
                [given([webBrowser.application canOpenURL:[NSURL URLWithString:@"https://google.com"]]) willReturnBool:YES];

                [webBrowser openURL:url];
                [(UIApplication *)verify(webBrowser.application) openURL:url];
            });
        });

        context(@"when multiple browsers are installed", ^{
            beforeEach(^{
                [given([webBrowser.application canOpenURL:anything()]) willReturnBool:YES];
            });

            context(@"when a default has not been set", ^{
                it(@"should prompt the user to pick", ^{
                    [webBrowser openURL:url];

                    UIViewController *presented = UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    expect(presented).will.beKindOf([UIActivityViewController class]);
                });

                it(@"should contain the correct activities", ^{
                    [webBrowser openURL:url];

                    UIActivityViewController *presented = (UIActivityViewController *)UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    NSArray *items = [presented applicationActivities];
                    expect(items.count).to.equal(2);
                });
            });

            xcontext(@"when a default has been set", ^{
                it(@"should use the default", ^{
                    // set default to Chrome

                    //[(UIApplication *)verify(app) openURL:[NSURL URLWithString:@"googlechrome://google.com"]];
                });
            });
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