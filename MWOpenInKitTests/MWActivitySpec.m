//
//  MWActivitySpec.m
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
#import "MWActivity.h"

@interface MWActivity (Spec)
@property UIImage *_activityImage;
@end

SpecBegin(MWActivity)

describe(@"MWActivity", ^{
    __block NSDictionary *dict;
    __block UIApplication *app;
    __block MWActivity *activity;

    beforeEach(^{
        app = mock([UIApplication class]);

        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"MWOpenInKit" withExtension:@"bundle"];
        NSBundle *bundle;
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }
        NSString *path = [bundle pathForResource:@"Chrome" ofType:@"plist"];
        dict = [NSDictionary dictionaryWithContentsOfFile:path];

        activity = [[MWActivity alloc] initWithActions:dict[@"actions"]
                                        optionalParams:dict[@"optional"]
                                                     name:@"Chrome"
                                              application:app];
    });

    describe(@"activityTitle", ^{
        it(@"should be the dictionary title", ^{
            expect(activity.activityTitle).to.equal(@"Chrome");
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