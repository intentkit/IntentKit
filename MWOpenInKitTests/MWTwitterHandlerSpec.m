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
#import "MWApplicationList.h"

@interface MWTwitterHandler (Spec)
@property UIApplication *application;
@property MWApplicationList *appList;
@end

SpecBegin(MWTwitterHandler)

describe(@"MWTwitterHandler", ^{
    __block MWTwitterHandler *handler;

    beforeEach(^{
        handler = [[MWTwitterHandler alloc] init];
        handler.application = mock([UIApplication class]);
        handler.appList = [[MWApplicationList alloc] initWithApplication:handler.application];
    });

    describe(@"passing along optional variables", ^{
        context(@"callback URL", ^{
            itShouldBehaveLike(@"an optional handler property", ^{
                return @{@"handler":  handler,
                         @"rawUrlString": @"tweetbot:///user_profile/{screenName}",
                         @"urlStringWithParam": @"tweetbot:///user_profile/ev?callback_url=http%3A%2F%2Fgoogle.com",
                         @"subjectAction": [^{
                             handler.callbackURL = [NSURL URLWithString:@"http://google.com"];
                             return [handler showUserWithScreenName:@"ev"];
                         } copy]};
            });
        });

        context(@"screen name", ^{
            itShouldBehaveLike(@"an optional handler property", ^{
                return @{@"handler":  handler,
                         @"urlStringWithoutParam": @"tweetbot://xxMyLittlePony42xx/timeline",
                         @"urlStringWithParam": @"tweetbot://xxMyLittlePony42xx/timeline",
                         @"subjectAction": [^{
                             handler.activeUser = @"xxMyLittlePony42xx";
                             return [handler showTimeline];
                         } copy]};
            });
        });
    });

    describe(@"Tweet by id", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://status?id=658273",
                     @"subjectAction": [^{
                         return [handler showTweetWithId:@"658273"];
                     } copy]};
        });
    });

    describe(@"User by handle", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://user?screen_name=lazerwalker",
                     @"subjectAction": [^{
                         return [handler showUserWithScreenName:@"lazerwalker"];
                     } copy]};
        });
    });

    describe(@"User by id", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://user?id=12345",
                     @"subjectAction": [^{
                         return [handler showUserWithId:@"12345"];
                     } copy]};
        });
    });

    describe(@"Timeline", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://timeline",
                     @"subjectAction": [^{
                         return [handler showTimeline];
                     } copy]};
        });
    });

    describe(@"Mentions", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"tweetbot:///mentions",
                     @"subjectAction": [^{
                         return [handler showMentions];
                     } copy]};
        });
    });

    describe(@"DMs", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"tweetbot:///direct_messages",
                     @"subjectAction": [^{
                         return [handler showDirectMessages];
                     } copy]};
        });
    });

    describe(@"Search", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://search?query=%23yoloswag%20for%20life",
                     @"subjectAction": [^{
                         return [handler searchFor:@"#yoloswag for life"];
                     } copy]};
        });
    });

    describe(@"Write a new tweet", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://post?message=HI%20MOM",
                     @"subjectAction": [^{
                         return [handler tweetMessage:@"HI MOM"];
                     } copy]};
        });
    });

    describe(@"Write a reply", ^{
        itShouldBehaveLike(@"a handler action", ^{
            return @{@"handler":  handler,
                     @"urlString": @"twitter://post?message=HI%20MOM&in_reply_to_status_id=12345",
                     @"subjectAction": [^{
                         return [handler tweetMessage:@"HI MOM" inReplyTo:@"12345"];
                     } copy]};
        });
    });
});

SpecEnd
