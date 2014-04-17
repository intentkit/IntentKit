//
//  IntentKit.h
//  Pods
//
//  Created by Michael Walker on 12/3/13.
//
//

#import "INKActivity.h"
#import "INKActivityPresenter.h"
#import "INKActivityViewController.h"

/** A mish-mosh of occasionally-useful methods */
@interface IntentKit : NSObject

/** A static singleton object */
+ (instancetype)sharedInstance;

/** Determines whether or not the current device is an iPad.
 @return YES if being run on an iPad (UIUserInterfaceIdiomPad), otherwise no. */
- (BOOL)isPad;

/** An array of the current device's preferred languages. */
- (NSArray *)preferredLanguages;

/** Finds the front-most view controller in the entire app.
 @return The currently-visible UIViewController */
- (UIViewController *)visibleViewController;

/** Finds the front-most view controller on a given UIViewController
 @param parent A UIViewController that may or may not have nested view controllers (modally presented, displayed as part of a navigation stack, etc)
 @return The currently-frontmost UIViewController with parent as a parent node.*/
- (UIViewController *)topViewController:(UIViewController *)parent;

/** Returns an image with a given name.
 Acts like [UImage imageNamed:], but fetches from the main IntentKit bundle.
 @param name The filename of a PNG image, no extension
 @return a valid UIImage, or `nil` if no such image exists in the bundle */
- (UIImage *)imageNamed:(NSString *)name;

@end
