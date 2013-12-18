//
//  MWTwitterHandler.h
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/3/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWHandler.h"

@class MWActivityPresenter;

/** An instance of `MWTwitterHandler` performs Twitter-related tasks in third-party Twitter apps. */
@interface MWTwitterHandler : MWHandler

/** Whether it should use a browser fallback or not */
@property (nonatomic) BOOL fallback;

/** A URL to be opened by the third-party app when the action has been completed. Not all third-party apps support callbacks. */
@property (strong, nonatomic) NSURL *callbackURL;

/** For Twitter clients that support multiple accounts, specifies the screen name of the account that should be used. */
@property (strong, nonatomic) NSString *activeUser;

/** Shows a specific single tweet
 @param tweetId The id of a status update
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showTweetWithId:(NSString *)tweetId;

/** @name Standard Twitter actions */

/** Shows the timeline of a given user
 @param screenName The screen name/handle of a Twitter user
 @return A `MWActivityPresenter` object to present.  */
- (MWActivityPresenter *)showUserWithScreenName:(NSString *)screenName;

/** Shows the timeline of a given user
 @param userId The user id of a Twitter user
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showUserWithId:(NSString *)userId;


/** Shows the timeline of the active user
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showTimeline;


/** Shows @mentions for the active user
 @return A `MWActivityPresenter` object to present.

 @warning The first-party Twitter app does not have a "mentions" screen any more. If this results in opening Twitter.app, the "Connect" page will be displayed, which aggregates @mentions, DMs, and favorites/retweets/etc. */
- (MWActivityPresenter *)showMentions;

/** Shows DMs for the active user
 @return A `MWActivityPresenter` object to present.
 
 @warning The first-party Twitter app does not have a "Messages" screen any more. If this results in opening Twitter.app, the "Connect" page will be displayed, which aggregates @mentions, DMs, and favorites/retweets/etc. */
- (MWActivityPresenter *)showDirectMessages;

/** Searches for tweets or users
 @param query A string to search for
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)searchFor:(NSString *)query;

/** Opens a window to compose a new tweet
 @param message The content to pre-populate the input box with
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)tweetMessage:(NSString *)message;

/** Opens a window to compose a new relpy
 @param message The content to pre-populate the input box with
 @param replyId The id of a tweet that the new tweet is a reply to.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)tweetMessage:(NSString *)message inReplyTo:(NSString *)replyId;

/** @name Standard Twitter actions */

/** Show retweets.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showRetweets;

/** Shows the tweets the current user has favorited
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showFavorites;

/** Shows the current user's lists.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showLists;

/** Shows a specific list.
 @param listId The id of a list
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)showListWithId:(NSString *)listId;

/** Shows the search screen.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)tweetSearchPage;

/** Follows a given user.
 @param user A screen name or user ID
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)followUser:(NSString *)user;

/** Unfollows a given user.
 @param user A screen name or user ID
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)unfollowUser:(NSString *)user;

/** Favorites a tweet.
 @param tweetId The ID of a tweet to favorite.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)favoriteTweetWithId:(NSString *)tweetId;

/** Unfavorites a tweet.
 @param tweetId The ID of a tweet to unfavorite.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)unfavoriteTweetWithId:(NSString *)tweetId;

/** Retweets a tweet.
 @param tweetId The ID of a tweet to retweet.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)retweetTweetWithId:(NSString *)tweetId;
@end
