#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "OKWebBrowser.h"

@interface OKWebBrowser (Spec)
@property UIApplication *application;
@end

@interface UIActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;

@end

SpecBegin(OKWebBrowser)

describe(@"OKWebBrowser", ^{
    __block OKWebBrowser *webBrowser;
    __block UIApplication *app;

    beforeEach(^{
        webBrowser = [[OKWebBrowser alloc] init];
        webBrowser.application = app = mock([UIApplication class]);
    });

    describe(@"Opening a URL", ^{
        __block NSURL *url;
        beforeEach(^{
            url = [NSURL URLWithString:@"http://google.com"];
        });

        context(@"when only Mobile Safari is installed", ^{
            it(@"should open in Mobile Safari", ^{
                [given([app canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) willReturnBool:NO];
                [given([app canOpenURL:[NSURL URLWithString:@"http://"]]) willReturnBool:YES];

                [webBrowser openURL:url];
                [(UIApplication *)verify(app) openURL:url];
            });
        });

        context(@"when multiple browsers are installed", ^{
            beforeEach(^{
                [given([app canOpenURL:anything()]) willReturnBool:YES];
            });

            context(@"when a default has not been set", ^{
                it(@"should prompt the user to pick", ^{
                    [webBrowser openURL:url];

                    UIViewController *presented = UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    expect(presented).will.beKindOf([UIActivityViewController class]);
                });

                it(@"should contain the correct activities", ^{
                    UIActivityViewController *presented = (UIActivityViewController *)UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    NSArray *items = [presented applicationActivities];
                    expect(items.count).to.equal(2);
                });
            });

            context(@"when a default has been set", ^{
                it(@"should use the default", ^{
                    // set default to Chrome

                    //[(UIApplication *)verify(app) openURL:[NSURL URLWithString:@"googlechrome://google.com"]];
                });
            });
        });
    });
});

SpecEnd