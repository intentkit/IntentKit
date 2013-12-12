//
//  MWTwitterHandler.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/3/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWTwitterHandler.h"

@implementation MWTwitterHandler

- (MWActivityPresenter *)showTweetWithId:(NSString *)tweetId {
    NSDictionary *args = [self argumentsDictionaryWithArguments:@{@"tweetId": tweetId}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:args];
}

- (MWActivityPresenter *)showUserWithScreenName:(NSString *)screenName {
    NSDictionary *args = [self argumentsDictionaryWithArguments:@{@"screenName": screenName}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:args];
}

- (MWActivityPresenter *)showUserWithId:(NSString *)userId {
    NSDictionary *args = [self argumentsDictionaryWithArguments:@{@"userId": userId}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:args];
}

- (MWActivityPresenter *)showTimeline {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)showMentions {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)showDirectMessages {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)searchFor:(NSString *)query {
    NSDictionary *arguments = [self argumentsDictionaryWithArguments:
                               @{@"query": urlEncode(query)}];

    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:arguments];
}

- (MWActivityPresenter *)tweetMessage:(NSString *)message {
    NSDictionary *arguments = [self argumentsDictionaryWithArguments:
                               @{@"message": urlEncode(message)}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:arguments];
}

- (MWActivityPresenter *)tweetMessage:(NSString *)message inReplyTo:(NSString *)replyId {
    NSDictionary *arguments = [self argumentsDictionaryWithArguments:
                               @{@"message": urlEncode(message),
                                 @"replyId": replyId}];
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:arguments];
}

#pragma mark - Actions not supported by all clients
- (MWActivityPresenter *)showRetweets {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)showFavorites {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)showLists {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)showListWithId:(NSString *)listId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(listId)]];
}

- (MWActivityPresenter *)tweetSearchPage {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:nil]];
}

- (MWActivityPresenter *)followUser:(NSString *)user {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(user)]];
}

- (MWActivityPresenter *)unfollowUser:(NSString *)user {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(user)]];
}

- (MWActivityPresenter *)favoriteTweetWithId:(NSString *)tweetId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(tweetId)]];
}

- (MWActivityPresenter *)unfavoriteTweetWithId:(NSString *)tweetId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(tweetId)]];
}

- (MWActivityPresenter *)retweetTweetWithId:(NSString *)tweetId {
    return [self performCommand:NSStringFromSelector(_cmd)
                  withArguments:[self argumentsDictionaryWithArguments:NSDictionaryOfVariableBindings(tweetId)]];
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
