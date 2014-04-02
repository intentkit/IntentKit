//
//  INKDefaultsManager.h
//  IntentKitDemo
//
//  Created by Michael Walker on 12/18/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** `INKDefaultsManager` manages saving which applications are preferred for
 different handler types. */
@interface INKDefaultsManager : NSObject

/** Returns the stored default application for a given handler class.
 @param handlerClass a subclass of INKHandler
 @param allowSystemDefault True if the system default should be returned in the
 case of no user preference.
 @return A string with the name of the application the user prefers */
- (NSString *)defaultApplicationForHandler:(Class)handlerClass
                        allowSystemDefault:(BOOL)allowSystemDefault;

/** Stores a default for a handler.
 @param appName The name (plist/folder name) of an application to be set as the default
 @param handlerClass The handler class to register the default for. */
- (void)addDefault:(NSString *)appName forHandler:(Class)handlerClass;

/** Remove the default app for a given handler
 @param handlerClass An INKHandler subclass */
- (void)removeDefaultForHandler:(Class)handlerClass;

/** Remove all saved defaults */
- (void)removeAllDefaults;


@end