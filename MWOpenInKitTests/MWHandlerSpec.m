//
//  MWHandlerSpec.m
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
#import "MWHandler.h"
#import "MWActivity.h"
#import "MWApplicationList.h"

@interface MWHandler (Spec)
@property UIApplication *application;
@property MWApplicationList *appList;
@end

SpecBegin(MWHandler)

describe(@"MWHandler", ^{
    __block MWHandler *handler;

    beforeEach(^{
        handler = [[MWHandler alloc] init];
        handler.application = mock([UIApplication class]);
        handler.appList = [[MWApplicationList alloc] initWithApplication:handler.application];
    });

    describe(@"canPerformCommand:", ^{
        context(@"when there are appropriate apps installed", ^{
            it(@"should return YES", ^{
                MWActivity *noActivity = mock([MWActivity class]);
                [given([noActivity canPerformCommand:@"doSomething"]) willReturnBool:NO];
                MWActivity *yesActivity = mock([MWActivity class]);
                [given([yesActivity canPerformCommand:@"doSomething"]) willReturnBool:YES];

                handler.appList = mock([MWApplicationList class]);
                [given([handler.appList activities]) willReturn:@[noActivity, yesActivity]];

                expect([handler canPerformCommand:@"doSomething"]).to.beTruthy();
            });
        });
        context(@"when there are no appropriate apps installed", ^{
            it(@"should return NO", ^{
                MWActivity *activity = mock([MWActivity class]);
                [given([activity canPerformCommand:@"doSomething"]) willReturnBool:NO];

                handler.appList = mock([MWApplicationList class]);
                [given([handler.appList activities]) willReturn:@[activity]];

                expect([handler canPerformCommand:@"doSomething"]).toNot.beTruthy();
            });
        });
    });
});

SpecEnd