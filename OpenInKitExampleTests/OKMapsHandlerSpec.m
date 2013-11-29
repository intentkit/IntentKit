#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "OKMapsHandler.h"
#import <MapKit/MapKit.h>

@interface OKMapsHandler (Spec)
@property UIApplication *application;
@end

@interface UIActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;
@end

SpecBegin(OKMapsHandler)

fdescribe(@"OKMapsHandler", ^{
    __block OKMapsHandler *mapsHandler;

    beforeEach(^{
        mapsHandler = [[OKMapsHandler alloc] init];
        mapsHandler.application = mock([UIApplication class]);
    });

    describe(@"Opening a search query", ^{
        __block CLLocationCoordinate2D center;
        __block NSString *query;
        __block NSString *appleString;
        __block NSString *googleString;

        beforeEach(^{
            query = @"Roberto's";
            center = CLLocationCoordinate2DMake(32.715, -117.1625);

            appleString = @"http://maps.apple.com/?q=Roberto's&ll=32.715000,-117.162500";
            googleString = @"comgooglemaps://?q=Roberto's&center=32.715000,-117.162500";
        });

        context(@"when only Apple Maps", ^{
            it(@"should open in Apple Maps", ^{
                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:googleString]]) willReturnBool:NO];
                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:appleString]]) willReturnBool:YES];

                [mapsHandler searchFor:query near:center];
                [(UIApplication *)verify(mapsHandler.application) openURL:[NSURL URLWithString:appleString]];
            });
        });

        context(@"when multiple maps apps are installed", ^{
            beforeEach(^{
                [given([mapsHandler.application canOpenURL:anything()]) willReturnBool:YES];
            });

            context(@"when a default has not been set", ^{
                it(@"should prompt the user to pick", ^{
                    [mapsHandler searchFor:query near:center];

                    UIViewController *presented = UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    expect(presented).will.beKindOf([UIActivityViewController class]);
                });

                it(@"should contain the correct activities", ^{
                    [mapsHandler searchFor:query near:center];

                    UIActivityViewController *presented = (UIActivityViewController *)UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    NSArray *items = [presented applicationActivities];
                    expect(items.count).to.equal(2);
                });
            });
        });
    });
});

SpecEnd