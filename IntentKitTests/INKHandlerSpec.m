//
//  INKHandlerSpec.m
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
#import "INKHandler.h"
#import "INKActivity.h"
#import "INKApplicationList.h"

@interface INKHandler (Spec)
@property UIApplication *application;
@property INKApplicationList *appList;
@end

SpecBegin(INKHandler)

describe(@"INKHandler", ^{
    __block INKHandler *handler;

    beforeEach(^{
        handler = [[INKHandler alloc] init];
        handler.application = mock([UIApplication class]);
        handler.appList = [[INKApplicationList alloc] initWithApplication:handler.application];
    });

    describe(@"canPerformCommand:", ^{
        context(@"when there are appropriate apps installed", ^{
            it(@"should return YES", ^{
                INKActivity *noActivity = mock([INKActivity class]);
                [given([noActivity canPerformCommand:@"doSomething"]) willReturnBool:NO];
                INKActivity *yesActivity = mock([INKActivity class]);
                [given([yesActivity canPerformCommand:@"doSomething"]) willReturnBool:YES];

                handler.appList = mock([INKApplicationList class]);
                [given([handler.appList activities]) willReturn:@[noActivity, yesActivity]];

                expect([handler canPerformCommand:@"doSomething"]).to.beTruthy();
            });
        });
        context(@"when there are no appropriate apps installed", ^{
            it(@"should return NO", ^{
                INKActivity *activity = mock([INKActivity class]);
                [given([activity canPerformCommand:@"doSomething"]) willReturnBool:NO];

                handler.appList = mock([INKApplicationList class]);
                [given([handler.appList activities]) willReturn:@[activity]];

                expect([handler canPerformCommand:@"doSomething"]).toNot.beTruthy();
            });
        });
    });
});

SpecEnd