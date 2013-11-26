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

SpecBegin(OKWebBrowser)

describe(@"OKWebBrowser", ^{
    __block OKWebBrowser *webBrowser;
    __block UIApplication *app;

    beforeEach(^{
        webBrowser = [[OKWebBrowser alloc] init];
        webBrowser.application = app = mock([UIApplication class]);
    });

    describe(@"Opening a URL", ^{
        context(@"when only Mobile Safari is installed", ^{
            it(@"should open in Mobile Safari", ^{
                [given([app canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) willReturnBool:NO];
                [given([app canOpenURL:[NSURL URLWithString:@"http://"]]) willReturnBool:YES];

                NSURL *url = [NSURL URLWithString:@"http://google.com"];
                [webBrowser openURL:url];
                [(UIApplication *)verify(app) openURL:url];

            });
        });

        context(@"when multiple browsers are installed", ^{
            context(@"when a default has not been set", ^{
                it(@"should prompt the user to pick", ^{

                });
            });

            context(@"when a default has been set", ^{
                it(@"should use the default", ^{
                    
                });
            });
        });
    });
});

SpecEnd