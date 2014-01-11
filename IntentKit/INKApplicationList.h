//
//  INKApplicationList.h
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/8/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A `INKApplicationList` is a data source that provides a list of third-party applications. */
@interface INKApplicationList : NSObject

/** Create a new `INKApplicationList` object for a given handler class.
 @param handlerClass An INKHandler subclass to load applications for. */
- (id)initWithHandler:(Class)handlerClass;

/** Custom constructor to stub out the UIApplication in test.
 @param application A UIApplication. In production, this should probably just be [UIApplication sharedApplication].
 @param handlerClass An INKHandler subclass to load applications for */
- (id)initWithApplication:(UIApplication *)application forHandler:(Class)handlerClass;

/** The INKHandler subclass to load applications for. */
@property (copy, nonatomic) Class handlerClass;

/** An array containing every possible
 third-party app for a given handler, including ones that the user doesn't have
 installed. */
@property (readonly) NSArray *activities;

/** Return the fallback URL, if applicable, for a given command
 @param command A command to return the fallback for
 @return A string containing a templated URL to load in an INKBrowserHandler, or nil if no fallback URL exists. */
- (NSString *)fallbackUrlForCommand:(NSString *)command;
@end
