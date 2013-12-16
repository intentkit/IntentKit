//
//  MWTwitterHandler.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/3/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWTwitterHandler.h"

@implementation MWTwitterHandler
@synthesize fallback;

- (id)init {
    self = [super init];
    if (self) {
        [self setFallback:NO];
    }

    return self;
}

- (MWActivityPresenter *)showTweetWithId:(NSString *)tweetId {
    NSDictionary *args = [self argumentsDictionaryWithArguments:@{@"tweetId": tweetId}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:args
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showUserWithScreenName:(NSString *)screenName {
    NSDictionary *args = [self argumentsDictionaryWithArguments:@{@"screenName": screenName}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:args
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showUserWithId:(NSString *)userId {
    NSDictionary *args = [self argumentsDictionaryWithArguments:@{@"userId": userId}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:args
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showTimeline {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showMentions {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showDirectMessages {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)searchFor:(NSString *)query {
    NSDictionary *arguments = [self argumentsDictionaryWithArguments:
                               @{@"query": urlEncode(query)}];

    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:arguments
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)tweetMessage:(NSString *)message {
    NSDictionary *arguments = [self argumentsDictionaryWithArguments:
                               @{@"message": urlEncode(message)}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:arguments
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)tweetMessage:(NSString *)message inReplyTo:(NSString *)replyId {
    NSDictionary *arguments = [self argumentsDictionaryWithArguments:
                               @{@"message": urlEncode(message),
                                 @"replyId": replyId}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:arguments
                  fallback:[self fallback]];
}

#pragma mark - Actions not supported by all clients
- (MWActivityPresenter *)showRetweets {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showFavorites {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showLists {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)showListWithId:(NSString *)listId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(listId)]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)tweetSearchPage {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)followUser:(NSString *)user {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(user)]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)unfollowUser:(NSString *)user {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(user)]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)favoriteTweetWithId:(NSString *)tweetId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(tweetId)]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)unfavoriteTweetWithId:(NSString *)tweetId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(tweetId)]
                  fallback:[self fallback]];
}

- (MWActivityPresenter *)retweetTweetWithId:(NSString *)tweetId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(tweetId)]
                  fallback:[self fallback]];
}

#pragma mark - Private methods
- (NSDictionary *)argumentsDictionaryWithArguments:(NSDictionary *)args {
    if (!args) {
        args = @{};
    }
    
    NSMutableDictionary *newArgs = [args mutableCopy];

    if (self.callbackURL) {
        newArgs[@"callbackURL"] = urlEncode(self.callbackURL.absoluteString);
    }

    if (self.activeUser) {
        newArgs[@"activeUser"] = self.activeUser;
    }

    if (!newArgs[@"activeUser"]) {
        newArgs[@"activeUser"] = @"";
    }

    return [newArgs copy];
}

@end
