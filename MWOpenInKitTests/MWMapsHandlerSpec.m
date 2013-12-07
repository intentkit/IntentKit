//
//  MWMapsHandlerSpec.m
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
#import "MWMapsHandler.h"
#import <MapKit/MapKit.h>

@interface MWMapsHandler (Spec)
@property UIApplication *application;
@end

SpecBegin(MWMapsHandler)

describe(@"MWMapsHandler", ^{
    __block MWMapsHandler *mapsHandler;

    beforeEach(^{
        mapsHandler = [[MWMapsHandler alloc] init];
        mapsHandler.application = mock([UIApplication class]);
    });

    describe(@"passing along optional variables", ^{
        context(@"when the center is set", ^{
            it(@"should pass along the center", ^{
                NSString *appleStringWithCenter = @"http://maps.apple.com/?q=Roberto%27s&ll=32.715000,-117.162500";
                NSString *appleStringWithoutCenter = @"http://maps.apple.com/?q=Roberto%27s";

                mapsHandler.center = CLLocationCoordinate2DMake(32.715, -117.1625);

                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:appleStringWithoutCenter]]) willReturnBool:YES];

                [mapsHandler searchForLocation:@"Roberto's"];
                [(UIApplication *)verify(mapsHandler.application) openURL:[NSURL URLWithString:appleStringWithCenter]];
            });
        });

        context(@"when the zoom is set", ^{
            it(@"should pass along the zoom", ^{
                NSString *appleStringWithZoom = @"http://maps.apple.com/?q=Roberto%27s&z=5";
                NSString *appleStringWithoutZoom = @"http://maps.apple.com/?q=Roberto%27s";

                mapsHandler.zoom = 5;

                [given([mapsHandler.application canOpenURL:[NSURL URLWithString:appleStringWithoutZoom]]) willReturnBool:YES];

                [mapsHandler searchForLocation:@"Roberto's"];
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
                         return [mapsHandler searchForLocation:@"Roberto's"];
                     } copy]};
        });
    });

    describe(@"Turn-by-turn directions", ^{
        context(@"without a mode", ^{
            itShouldBehaveLike(@"a handler action", ^{
                return @{@"handler":  mapsHandler,
                         @"urlString": @"http://maps.apple.com/?saddr=New%20Jersey&daddr=California",
                         @"maxApps": @2,
                         @"subjectAction": [^{
                             return [mapsHandler directionsFrom:@"New Jersey" to:@"California"];
                         } copy]};
            });
        });

        context(@"with a directions mode", ^{
            itShouldBehaveLike(@"a handler action", ^{
                return @{@"handler":  mapsHandler,
                         @"urlString": @"comgooglemaps://?saddr=New%20Jersey&daddr=California&directionsmode=walking",
                         @"maxApps": @2,
                         @"subjectAction": [^{
                             return [mapsHandler directionsFrom:@"New Jersey" to:@"California" mode:MWMapsHandlerDirectionsModeWalking];
                         } copy]};
            });
        });
    });
});

SpecEnd