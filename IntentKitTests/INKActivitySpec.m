//
//  INKActivitySpec.m
//  INKOpenInKitTests
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
#import "INKActivity.h"
#import "IntentKit.h"

@interface INKActivity (Spec)
@property UIImage *_activityImage;
@property IntentKit *intentKit;
@end

SpecBegin(INKActivity)

describe(@"INKActivity", ^{
    __block NSDictionary *dict;
    __block UIApplication *app;
    __block INKActivity *activity;

    beforeEach(^{
        app = mock([UIApplication class]);

        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
        NSBundle *bundle;
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }
        NSString *path = [bundle pathForResource:@"Chrome" ofType:@"plist"];
        dict = [NSDictionary dictionaryWithContentsOfFile:path];

        activity = [[INKActivity alloc] initWithActions:dict[@"actions"]
                                           fallbackUrls:dict[@"fallbackUrls"]                                         optionalParams:dict[@"optional"]
                                                   name:@"Chrome"
                                            application:app];
    });

    describe(@"activityTitle", ^{
        context(@"when the application has a single name", ^{
            it(@"should use it", ^{
                expect(activity.activityTitle).to.equal(@"Chrome");
            });
        });

        context(@"when the application has localized names", ^{
            beforeEach(^{
                activity = [[INKActivity alloc] initWithActions:dict[@"actions"]
                                                   fallbackUrls:dict[@"fallbackUrls"]
                                                 optionalParams:dict[@"optional"]
                                                          names:@{@"en": @"English",
                                                                  @"de": @"Deutsch",
                                                                  @"fr": @"Français"}
                                                    application:app];
                activity.intentKit = mock([IntentKit class]);
            });

            context(@"when the preferred language is available", ^{
                it(@"should use it", ^{
                    [given([activity.intentKit preferredLanguages]) willReturn:@[@"fr"]];
                    expect(activity.activityTitle).to.equal(@"Français");
                });
            });

            context(@"when a less-preferred language is available", ^{
                it(@"should use it", ^{
                    [given([activity.intentKit preferredLanguages]) willReturn:@[@"ja", @"de"]];
                    expect(activity.activityTitle).to.equal(@"Deutsch");
                });
            });

            context(@"when no preferred languages are available", ^{
                it(@"should use the English name", ^{
                    [given([activity.intentKit preferredLanguages]) willReturn:@[@"ja"]];
                    expect(activity.activityTitle).to.equal(@"English");
                });

                context(@"when English does not exist", ^{
                    it(@"should use the first one it finds", ^{
                        activity = [[INKActivity alloc] initWithActions:dict[@"actions"]
                                                           fallbackUrls:dict[@"fallbackUrls"]
                                                         optionalParams:dict[@"optional"]
                                                                  names:@{@"de": @"Deutsch",
                                                                          @"fr": @"Français"}
                                                            application:app];
                        activity.intentKit = mock([IntentKit class]);

                        [given([activity.intentKit preferredLanguages]) willReturn:@[@"ja"]];
                        expect(activity.activityTitle).to.equal(@"Deutsch");
                    });
                });
            });
        });
    });

    describe(@"activityType", ^{
        it(@"should be the dictionary title", ^{
            expect(activity.activityType).to.equal(@"Chrome");
        });
    });

    describe(@"activityImage", ^{
        it(@"should be the correct image", ^{
            expect(activity._activityImage).notTo.beNil();
        });
    });

    describe(@"performActivity", ^{
        it(@"should open the correct URL", ^{
            [activity prepareWithActivityItems:@[@"openHttpURL:", @{@"url": @"google.com"}]];
            [activity performActivity];
            [(UIApplication *)verify(app) openURL:[NSURL URLWithString:@"googlechrome://google.com"]];
        });
    });
});

SpecEnd