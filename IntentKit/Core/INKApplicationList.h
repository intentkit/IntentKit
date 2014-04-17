//
//  INKApplicationList.h
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/8/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

@class INKActivity;

/** A `INKApplicationList` is a data source that provides a list of third-party applications. */
@interface INKApplicationList : NSObject

/** Lists all handler objects currently available
 @return An NSArray of Class objects representing INKHandler subclasses. */
+ (NSArray *)availableHandlers;

/** Create a new `INKApplicationList` object for a given handler class.
 @param handlerClass An INKHandler subclass to load applications for. */
- (id)initWithHandler:(Class)handlerClass;

/** Custom constructor to stub out the UIApplication in test.
 @param application A UIApplication. In production, this should probably just be [UIApplication sharedApplication].
 @param handlerClass An INKHandler subclass to load applications for */
- (id)initWithApplication:(UIApplication *)application forHandler:(Class)handlerClass;

/** The INKHandler subclass to load applications for. */
@property (copy, nonatomic) Class handlerClass;

/** If true, will not include the first-party external application registered
 for the handler in its list of available activities.*/
@property (assign, nonatomic) BOOL hideFirstPartyApp;

/** If true, will not include a modal in-app activity registered
 for the handler in its list of available activities.*/
@property (assign, nonatomic) BOOL hideInApp;

/** An array containing every possible app for a given handler,
 including ones that the user doesn't have installed. */
@property (readonly) NSArray *activities;

/** An array containing only the applications the user currently has installed
 for the given handler. */
@property (readonly) NSArray *availableActivities;

/** True if the handler class enables falling back onto a web browser */
@property (readonly) BOOL canUseFallback;

/** Returns the activity for a given app name
 @param name A string containing the English name of an app belonging to the current handler class
 @return An INKActivity object representing that application */
- (INKActivity *)activityWithName:(NSString *)name;

/** Return the fallback URL, if applicable, for a given command
 @param command A command to return the fallback for
 @return A string containing a templated URL to load in an INKBrowserHandler, or nil if no fallback URL exists. */
- (NSString *)fallbackUrlForCommand:(NSString *)command;
@end
