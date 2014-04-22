//
//  INKActivity.h
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKPresentable.h"

/** A subclass of `UIActivity` that presents either (1) a single third-party application capable of opening a given URL scheme or set of URL schemes, or (2) a modal view controller capable of handling one or more actions.
 
 Typically, the dictionary of accepted URL schemes and the name of the application should come from the contents of a plist file and its filename, respetively. In practice, you shouldn't need to manually initialize an `INKActivity` outside of the `INKHandler` class.
 
 @warning `INKActivity`'s implementation of the `UIActivity` method `canPerformWithActivityItems:` always returns `YES`. It is your responsibility to ensure that an INKActivity can actually respond to a URL (using `canPerformCommand:withArguments:`) before adding it to a `UIActivityViewController`
 
 @warning `INKActivity` currently makes use of the private method `_activityImage` to coax the `UIActivityViewController` into displaying a full-color image rather than creating a black-and-white representation using the `UIImage` returned by `activityImage` as a mask. It remains to be seen whether Apple will allow this private API usage or not. */
@interface INKActivity : UIActivity

/** The internal name of the application. May differ from what is displayed to the user.
 Namely, most modal/in-app activities have a unique `name` identifier 
 while their `localizedName` is a localized version of the string "In App". */
@property (readonly) NSString *name;

/** The localized name of the application, taking the device's current language
 preferences into account. For many applications, this will always be the same 
 as `name`. */
@property (readonly) NSString *localizedName;

/** If the handler shows a view controller rather than opening a URL, this is
 an INKPresentable object to perform actions on. */
@property (readonly) id<INKPresentable> presenter;

/** True if the device currently has this application available to use */
@property (readonly) BOOL isAvailableOnDevice;

/** A dictionary of URL schemes an application responds to. The keys are command names, and the values are handlebar-templated strings that can be used to construct a valid URL. */
@property (strong, nonatomic) NSDictionary *actions;

/** A dictionary of optional properties that may be amended to a URL. The keys are variable names, and the values are handlebar-templated strings that can be safely appended to the end of the URL. */
@property (strong, nonatomic) NSDictionary *optionalParams;

/** The NSBundle to load the app icon from */
@property (strong, nonatomic) NSBundle *bundle;

/** Returns an initialized `INKActivity` object.

 @param presenter An INKPresentable object that will have `performAction:params:inViewController:` called on it when it is time to perform an action.
 @param actions The dictionary mapping commands to valid URL schemes for the third-party application.
 @param internalName An string to uniquely identify this activity.
 @param names A dictionary of localized app names. The keys are short locale names (e.g. `en`, `fr`), the values are strings representing the name for the given locale.
 @param application The UIApplication to use when calling `[UIApplication openURL:]` and `[UIApplication canOpenURL:]`. You probably want this to be `[UIApplication sharedApplication]`, but it is injected here for test purposes.
 @param bundle the NSBundle to fetch the app icon from.

 @return an initialized `INKActivity` object. */
- (instancetype)initWithPresenter:(id<INKPresentable>)presenter
                          actions:(NSArray *)actions
                     internalName:(NSString *)internalName
                            names:(NSDictionary *)names
                      application:(UIApplication *)application
                           bundle:(NSBundle *)bundle;

/** Returns an intialized `INKActivity` object.

 @param actions The dictionary mapping commands to valid URL schemes for the third-party application.
 @param optionalParams The dictionary listing which optional parameters are accepted.
 @param names A dictionary of localized app names. The keys are short locale names (e.g. `en`, `fr`), the values are strings representing the name for the given locale.
 @param application The UIApplication to use when calling `[UIApplication openURL:]` and `[UIApplication canOpenURL:]`. You probably want this to be `[UIApplication sharedApplication]`, but it is injected here for test purposes.
 @param bundle the NSBundle to fetch the app icon from.
 @return an initialized `INKActivity` object. */
- (instancetype)initWithActions:(NSDictionary *)actions
                 optionalParams:(NSDictionary *)optionalParams
                         names: (NSDictionary *)names
                    application:(UIApplication *)application
                         bundle:(NSBundle *)bundle;

/** Checks whether or not the third-party app can accept a custom URL corresponding to a given command
 
 @param command A command to perform. If the third-party app knows how to perform this command, it should have a corresponding key in the activity's `dict` property.
 
 @return YES if the third-party app responds to a custom URL scheme to perform the corresponding command.*/
- (BOOL)canPerformCommand:(NSString *)command;


/** Performs an activity.

 @param presentingViewController The view controller that the activity should presented modally on. This is only used if the activity triggers a modal view controller, rather than an external URL. */
- (void)performActivityInViewController:(UIViewController *)presentingViewController;

@end
