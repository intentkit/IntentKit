#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "OKHandler.h"

@interface OKHandler (Spec)
@property UIApplication *application;
@end

@interface UIActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;
@end

SharedExamplesBegin(OKHandler)

sharedExamplesFor(@"a handler action", ^(NSDictionary *data) {
    __block OKHandler *handler;
    __block NSString *urlString;
    __block NSUInteger maxApps;
    __block void(^subjectAction)(void);

    beforeEach(^{
        handler.application = mock([UIApplication class]);

        handler = data[@"handler"];
        urlString = data[@"urlString"];
        maxApps = [data[@"maxApps"] intValue];
        subjectAction = data[@"subjectAction"];
    });

    context(@"when only one application is available", ^{
        it(@"should open in that application", ^{
            [given([handler.application canOpenURL:[NSURL URLWithString:urlString]]) willReturnBool:YES];

            subjectAction();

            [(UIApplication *)verify(handler.application) openURL:[NSURL URLWithString:urlString]];
        });
    });

    context(@"when multiple apps are installed", ^{
        beforeEach(^{
            [given([handler.application canOpenURL:anything()]) willReturnBool:YES];
        });

        context(@"when a default has not been set", ^{
            it(@"should prompt the user to pick", ^{
                subjectAction();

                UIViewController *presented = UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                expect(presented).will.beKindOf([UIActivityViewController class]);
            });

            it(@"should contain the correct activities", ^{
                subjectAction();

                UIActivityViewController *presented = (UIActivityViewController *)UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                NSArray *items = [presented applicationActivities];
                expect(items.count).to.equal(maxApps);
            });
        });
    });
});

SharedExamplesEnd