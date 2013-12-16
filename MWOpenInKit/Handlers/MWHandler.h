//
//  MWHandler.h
//  MWOpenInKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

NSString *(^urlEncode)(NSString *);

@class MWActivityPresenter;

/** `MWHandler` is the base class for shared groups of behavior for a class of third-party applications. You cannot use the `MWHandler` class directly. It instead defines the common interface and behavioral structure for all its subclasses.

 ## Subclassing Notes

 If you are defining URL schemes for a new discrete class of third-party applications (such as "web browsers" or "mapping applications", you may want to create your own `MWHandler` subclass. All custom methods you create that perform actions should ultimately return a UIActivityController created by calling performCommand:withArguments:. */
@interface MWHandler : NSObject

/** An array of MWActivity objects that represent all apps, regardless of whether they are available or relevant */
@property (strong, readonly) NSArray *activities;

/** Returns whether or not an action can be performed at all.
 @param command The name of a command to perform, corresponding with the keys in each application's plist.
 @return YES if the user has at least one application installed that responds to the given command.
 */
- (BOOL)canPerformCommand:(NSString *)command;

/** Opens a third-party application to perform some task.
 If there is only one application installed that can respond to that command, it will open that app with the correct URL.
 Otherwise, it will create a `UIActivityViewController` to prompt the user to pick an app.

 @param command The name of a command to perform, corresponding with keys in each application's plist.
 @param args The dictionary of arguments used to construct a URL based on the templates defined for each URL scheme.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args;

/** Opens a third-party application to perform some task.
 If there is only one application installed that can respond to that command, it will open that app with the correct URL.
 Otherwise, it will create a `UIActivityViewController` to prompt the user to pick an app.

 @param command The name of a command to perform, corresponding with keys in each application's plist.
 @param args The dictionary of arguments used to construct a URL based on the templates defined for each URL scheme.
 @param fallback If it should fallback to Browser, if possible.
 @return A `MWActivityPresenter` object to present. */
- (MWActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args fallback:(BOOL)fallback;

@end
