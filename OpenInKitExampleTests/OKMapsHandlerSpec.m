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

describe(@"OKMapsHandler", ^{
    __block OKMapsHandler *mapsHandler;

    beforeEach(^{
        mapsHandler = [[OKMapsHandler alloc] init];
        mapsHandler.application = mock([UIApplication class]);
    });

    describe(@"passing along optional variables", ^{
        context(@"when the center is set", ^{
            it(@"should pass along the center", ^{
                NSString *appleStringWithCenter = @"http://maps.apple.com/?q=Roberto%27s&ll=32.715000,-117.162500";
                NSString *appleStringWithoutCenter = @"http://maps.apple.com/?q=Roberto%27s";

                mapsHandler.center = CLLocationCoordinate2DMake(32.715, -117.1625);

                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:appleStringWithoutCenter]]) willReturnBool:YES];

                [mapsHandler searchFor:@"Roberto's"];
                [(UIApplication *)verify(mapsHandler.application) openURL:[NSURL URLWithString:appleStringWithCenter]];
            });
        });

        context(@"when the zoom is set", ^{
            it(@"should pass along the zoom", ^{
                NSString *appleStringWithZoom = @"http://maps.apple.com/?q=Roberto%27s&z=5";
                NSString *appleStringWithoutZoom = @"http://maps.apple.com/?q=Roberto%27s";

                mapsHandler.zoom = 5;

                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:appleStringWithoutZoom]]) willReturnBool:YES];

                [mapsHandler searchFor:@"Roberto's"];
                [(UIApplication *)verify(mapsHandler.application) openURL:[NSURL URLWithString:appleStringWithZoom]];
            });
        });
    });

    describe(@"Opening a search query", ^{
        __block CLLocationCoordinate2D center;
        __block NSString *query;
        __block NSString *appleString;
        __block NSString *googleString;

        beforeEach(^{
            query = @"Roberto's";
            center = CLLocationCoordinate2DMake(32.715, -117.1625);

            appleString = @"http://maps.apple.com/?q=Roberto%27s";
            googleString = @"comgooglemaps://?q=Roberto%27s";
        });

        context(@"when only Apple Maps", ^{
            it(@"should open in Apple Maps", ^{
                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:googleString]]) willReturnBool:NO];
                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:appleString]]) willReturnBool:YES];

                [mapsHandler searchFor:query];
                [(UIApplication *)verify(mapsHandler.application) openURL:[NSURL URLWithString:appleString]];
            });
        });

        context(@"when multiple maps apps are installed", ^{
            beforeEach(^{
                [given([mapsHandler.application canOpenURL:anything()]) willReturnBool:YES];
            });

            context(@"when a default has not been set", ^{
                it(@"should prompt the user to pick", ^{
                    [mapsHandler searchFor:query];

                    UIViewController *presented = UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    expect(presented).will.beKindOf([UIActivityViewController class]);
                });

                it(@"should contain the correct activities", ^{
                    [mapsHandler searchFor:query];

                    UIActivityViewController *presented = (UIActivityViewController *)UIApplication.sharedApplication.delegate.window.rootViewController.presentedViewController;
                    NSArray *items = [presented applicationActivities];
                    expect(items.count).to.equal(2);
                });
            });
        });
    });
});

SpecEnd