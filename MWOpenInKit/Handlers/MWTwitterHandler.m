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
