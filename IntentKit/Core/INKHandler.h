//
//  INKHandler.h
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKActivityViewController.h"
#import "INKActivityPresenter.h"

typedef NS_ENUM(NSInteger, INKHandlerCategory) {
    INKHandlerCategoryUtility,
    INKHandlerCategorySocialNetwork,
    INKHandlerCategoryUnknown
};

@class INKActivityPresenter;

/** `INKHandler` is the base class for shared groups of behavior for a class of third-party applications. You cannot use the `INKHandler` class directly. It instead defines the common interface and behavioral structure for all its subclasses.

 ## Subclassing Notes

 If you are defining URL schemes for a new discrete class of third-party applications (such as "web browsers" or "mapping applications", you may want to create your own `INKHandler` subclass. All custom methods you create that perform actions should ultimately return a UIActivityController created by calling performCommand:withArguments:. */
@interface INKHandler : NSObject<INKActivityViewControllerDefaultsDelegate>

/** The name of the currently-registered default app. This app might not be able
to handle all actions; in that case, a fallback activity view will be shown. */
@property (readonly) NSString *defaultApp;

/** If YES, when this handler is presented as an activity sheet, it will never
 show the "Remember My Choice" toggle. */
@property (assign, nonatomic) BOOL disableSettingDefault;

/** By default, if a handler has both a first-party app and an in-app modal view
 (e.g. Safari and an in-app UIWebView), the first-party app won't be displayed.

 Setting this to YES will show the first-party app as an option. */
@property (nonatomic, assign) BOOL showFirstPartyApp;

/** If a handler has an "In App" option (e.g. an in-app UIWebView for 
 INKBrowserHandler), setting this to YES will disable it */
@property (nonatomic, assign) BOOL disableInAppOption;

/** If no apps are available to perform a given task, if `fallback` is set to YES then the handler will attempt to perform the task in a web browser instead. YES by default. */
@property (nonatomic) BOOL useFallback;

/** By default, if there is only one valid application, a handler will automatically open that app instead of showing a `INKActivityViewController`. Setting this to `YES` overrides that behavior and always shows an activity view.

 This is mostly useful for demo purposes (e.g. running in the simulator). */
@property (nonatomic, assign) BOOL alwaysShowActivityView;

/** If true, this handler object will use a system-provided default if the
user has not provided one.
 
 To be clear: this means that performing an action with this handler will NEVER prompt the user to set a preference. In order to allow user preferences if this option is set, you will need to give users a way to explicitly set preferences, either by using an `INKDefaultsViewController` or creating your own interface. */
@property (nonatomic, assign) BOOL useSystemDefault;

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
 @return A `INKActivityPresenter` object to present. */
- (INKActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args;

/** The category of activity handled by the handler.
 This is used to group handlers in INKDefaultsViewController */
+ (INKHandlerCategory) category;

/** The name of the class of applications represented by the handler. */
+ (NSString *)name;

/** Prompts the user to pick a default application for the handler
 @return An `INKActivityPresenter` object to present. */
- (INKActivityPresenter *)promptToSetDefault;
@end
