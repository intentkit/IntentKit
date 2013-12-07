//
//  MWTwitterHandler.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/4/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "MWTwitterHandler.h"

@interface MWTwitterHandler (Spec)
@property UIApplication *application;
@end

@interface UIActivityViewController (Spec)
@property NSArray *activityItems;
@property NSArray *applicationActivities;

@end

SpecBegin(MWTwitterHandler)

describe(@"MWTwitterHandler", ^{
    __block MWTwitterHandler *handler;

    beforeEach(^{
        handler = [[MWTwitterHandler alloc] init];
        handler.application = mock([UIApplication class]);
    });

    describe(@"Tweet by id", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://status?id=658273",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler showTweetWithId:@"658273"];
                     } copy]};
        });
    });

    describe(@"User by handle", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://user?screen_name=lazerwalker",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler showUserWithScreenName:@"lazerwalker"];
                     } copy]};
        });
    });

    describe(@"User by id", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://user?id=12345",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler showUserWithId:@"12345"];
                     } copy]};
        });
    });

    describe(@"Timeline", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://timeline",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler showTimeline];
                     } copy]};
        });
    });

    describe(@"Mentions", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://mentions",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler showMentions];
                     } copy]};
        });
    });

    describe(@"DMs", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://direct_messages",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler showDirectMessages];
                     } copy]};
        });
    });

    describe(@"Search", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://search?query=%23yoloswag%20for%20life",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler searchFor:@"#yoloswag for life"];
                     } copy]};
        });
    });

    describe(@"Write a new tweet", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://post?message=HI%20MOM",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler tweetMessage:@"HI MOM"];
                     } copy]};
        });
    });

    describe(@"Write a reply", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://post?message=HI%20MOM&in_reply_to_status_id=12345",
                     @"maxApps": @2,
                     @"subjectAction": [^{
                         return [handler tweetMessage:@"HI MOM" inReplyTo:@"12345"];
                     } copy]};
        });
    });
});

SpecEnd
