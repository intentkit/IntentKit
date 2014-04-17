//
//  INKActivityPresenter.h
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/10/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INKActivityViewController;
@class INKActivity;

/** `INKActivityPresenter` is a presenter object responsible for displaying a `INKActivityViewController`. It will take care of displaying it modally on an iPhone or in a UIPopover on an iPad. */
@interface INKActivityPresenter : NSObject

/** An `INKActivityViewController` to be displayed. This will be nil if the user
 doesn't need to choose an application (e.g. they only have one installed, or
 have set a preference). */
@property (strong, nonatomic) INKActivityViewController *activitySheet;

/** An `INKActivity` to be performed if the user doesn't need to choose an
 application (e.g. they only have one installed, or have set a preference). Nil
 if there is a view controller to be presented instead. */
@property (strong, nonatomic) INKActivity *activity;

/** Instantiate a `INKActivityPresenter` with a given `INKActivityViewController`.
 @param activitySheet The `INKActivityViewController` that will be presentd. */
- (instancetype)initWithActivitySheet:(INKActivityViewController *)activitySheet;

/** Instantiate a `INKActivityPresenter` with a given `INKActivity`.
 @param activity The `INKActivity` whose action will be performed. */
- (instancetype)initWithActivity:(INKActivity *)activity;

/** Returns whether or not an action will be performed when you try to present the activity sheet.
 @return NO if the user has no applications installed capable of handling the action. Otherwise YES. */
- (BOOL)canPerformActivity;

/** Removes the active `INKActivityViewController` from view.
 @param animaed Whether or not to animate the transition */
- (void)dismissActivitySheetAnimated:(BOOL)animated;

/** Present the current activity sheet modally. 
 
 @warning This attempts to programmatically determine the topmost view 
 controller and present on that; if that does not work in your app, you probably
 want to manually pass in a view controller using `presentModalActivitySheetFromViewController:completion.*/
- (void)presentModally;

/** Present the current activity sheet modally.
 @param completion A completion block to be called after the user has dismissed
 the activity sheet.

 @warning This attempts to programmatically determine the topmost view
 controller and present on that; if that does not work in your app, you probably
 want to manually pass in a view controller using `presentModalActivitySheetFromViewController:completion.*/
- (void)presentModallyWithCompletion:(void(^)())completion;

/** Present the current activity sheet modally on a given view controller.
 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController.
 @param completion A completion block to be called after the user has dismissed the activity sheet

 @warning If your app is either Universal or iPad-only, you should instead use presentModalActivitySheetFromViewController:popoverFromRect:inView:permittedArrowDirections: or presentModalActivitySheetFromViewController:popoverFromBarButtonItem:permittedArrowDirections: instead.
*/
- (void)presentModalActivitySheetFromViewController:(UIViewController *)presentingViewController
                                         completion:(void(^)())completion;

/** Present the current activity sheet on the given view controller. If the device is an iPhone, it will be presented modally; if an iPad, it will be presented in a UIPopoverController with the given options. 
 
 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController.
 @param rect The CGRect the UIPopoverController should be originating from.
 @param view The UIView the UIPopoverController should be displayed in.
 @param arrowDirections A bitmask of permitted arrow directions.
 @param animated Whether or not to animate the popover.
 @param completion A completion block to be called after the user has dismissed the activity sheet
 @see UIPopoverController presentPopoverFromRect:inView:permittedArrowDirections:animated: */
- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController
                               popoverFromRect:(CGRect)rect
                                        inView:(UIView *)view
                      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                      animated:(BOOL)animated
                                    completion:(void(^)())completion;

/** Present the current activity sheet on the given view controller. If the device is an iPhone, it will be presented modally; if an iPad, it will be presented in a UIPopoverController with the given options.

 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController.
 @param item A UIBarButtonItem to originate the UIPopoverController from
 @param arrowDirections A bitmask of permitted arrow directions.
 @param animated Whether or not to animate the popover.
 @param completion A completion block to be called after the user has dismissed the activity sheet

 @see UIPopoverController presentPopoverFromRect:inView:permittedArrowDirections:animated: */
- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController
                      popoverFromBarButtonItem:(UIBarButtonItem *)item
                      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                      animated:(BOOL)animated
                                    completion:(void(^)())completion;

@end
