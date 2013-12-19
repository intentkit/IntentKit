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

/** An array containing INKActivity objects representing every possible third-party app, 
 including ones that aren't installed or aren't relevant to a given handler. */
@property (readonly) NSArray *activities;

/** Custom constructor to stub out the UIApplication in test.
 @param application A UIApplication. In production, this should probably just be [UIApplication sharedApplication]. */
- (instancetype)initWithApplication:(UIApplication *)application;

/** Return the fallback URL, if applicable, for a given handler and command 
 @param handlerClass An INKHandler subclass 
 @param command A command to return the fallback for
 @return A string containing a templated URL to load in an INKBrowserHandler, or nil if no fallback URL exists. */
- (NSString *)fallbackUrlForHandler:(Class)handlerClass command:(NSString *)command;
@end
