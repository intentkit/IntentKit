//
//  MWTwitterHandler.h
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/3/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWHandler.h"

/** An instance of `MWTwitterHandler` performs Twitter-related tasks in third-party Twitte rapps. */
@interface MWTwitterHandler : MWHandler

/** A URL to be opened by the third-party app when the action has been completed. Not all third-party apps support callbacks. */
@property (strong, nonatomic) NSURL *callbackURL;

/** For Twitter clients that support multiple accounts, specifies the screen name of the account that should be used. */
@property (strong, nonatomic) NSURL *screenName;

/** Shows a specific single tweet
 @param tweetId The id of a status update
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)showTweetWithId:(NSString *)tweetId;


/** Shows the timeline of a given user
 @param screenName The screen name/handle of a Twitter user
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)showUserWithScreenName:(NSString *)screenName;

/** Shows the timeline of a given user
 @param userId The user id of a Twitter user
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)showUserWithId:(NSString *)userId;


/** Shows the timeline of the active user
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)showTimeline;


/** Shows @mentions for the active user
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil.
 
 @warning The first-party Twitter app does not have a "mentions" screen any more. If this results in opening Twitter.app, the "Connect" page will be displayed, which aggregates @mentions, DMs, and favorites/retweets/etc. */
- (UIActivityViewController *)showMentions;

/** Shows DMs for the active user
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil.

  @warning The first-party Twitter app does not have a "Messages" screen any more. If this results in opening Twitter.app, the "Connect" page will be displayed, which aggregates @mentions, DMs, and favorites/retweets/etc. */
- (UIActivityViewController *)showDirectMessages;

/** Searches for tweets or users
 @param query A string to search for
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil.*/
- (UIActivityViewController *)searchFor:(NSString *)query;

/** Opens a window to compose a new tweet
 @param message The content to pre-populate the input box with
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)tweetMessage:(NSString *)message;

/** Opens a window to compose a new relpy
 @param message The content to pre-populate the input box with
 @param replyId The id of a tweet that the new tweet is a reply to.
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)tweetMessage:(NSString *)message inReplyTo:(NSString *)replyId;

/**---------------------------------------------------------------
 * @name Actions which may not be supported by all Twitter clients
 *--------------------------------------------------------------*/

//- (UIActivityViewController *)showRetweets;
//
//- (UIActivityViewController *)showFavorites;
//
//- (UIActivityViewController *)showLists;
//
//- (UIActivityViewController *)showListWithId:(NSString *)listId;
//
//- (UIActivityViewController *)showList:(NSString *)list byUser:(NSString *)screenName;

//- (UIActivityViewController *)search;


//- (UIActivityViewController *)followUser:(NSString *)user;
//
//- (UIActivityViewController *)unfollowUser:(NSString *)user;
//
//- (UIActivityViewController *)favoriteTweetWithId:(NSString *)tweetId;
//
//- (UIActivityViewController *)unfavoriteTweetWithId:(NSString *)tweetId;
//
//- (UIActivityViewController *)retweetTweetWithId:(NSString *)tweetId;
@end
