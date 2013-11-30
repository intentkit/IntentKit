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

    describe(@"Search query", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  mapsHandler,
                     @"urlString": @"http://maps.apple.com/?q=Roberto%27s",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         [mapsHandler searchFor:@"Roberto's"];
                     } copy]};
        });
    });

    fdescribe(@"Turn-by-turn directions", ^{
        context(@"without a mode", ^{
            itShouldBehaveLike(@"a handler action", ^{
                return @{@"handler":  mapsHandler,
                         @"urlString": @"http://maps.apple.com/?saddr=New%20Jersey&daddr=California",
                         @"maxApps": @2,
                         @"subjectAction": [^{
                             [mapsHandler directionsFrom:@"New Jersey" to:@"California"];
                         } copy]};
            });
        });

        context(@"with a directions mode", ^{
            itShouldBehaveLike(@"a handler action", ^{
                return @{@"handler":  mapsHandler,
                         @"urlString": @"comgooglemaps://?saddr=New%20Jersey&daddr=California&directionsmode=walking",
                         @"maxApps": @2,
                         @"subjectAction": [^{
                             [mapsHandler directionsFrom:@"New Jersey" to:@"California" mode:OKMapsHandlerDirectionsModeWalking];
                         } copy]};
            });
        });
    });
});

SpecEnd