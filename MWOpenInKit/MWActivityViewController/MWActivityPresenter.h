//
//  MWActivityPresenter.h
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/10/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MWActivityViewController;

/** `MWActivityPresenter` is a presenter object responsible for displaying a `MWActivityViewController`. It will take care of displaying it modally on an iPhone or in a UIPopover on an iPad. */
@interface MWActivityPresenter : NSObject

/** The `MWActivityViewController` to be displayed */
@property (strong, nonatomic) MWActivityViewController *activitySheet;


/** By default, if there is only one valid application, a `MWActivityViewController` will automatically open that app instead of showing a `MWActivityViewController`. Setting this to `YES` overrides that behavior and always shows an activity view.

 This is mostly useful for demo purposes (e.g. running in the simulator). */
@property (nonatomic, assign) BOOL alwaysShowActivityView;


/** Instantiate a `MWActivityPresenter` with a given `MWActivityViewController`.
 @param activitySheet The `MWActivityViewController` that will be presentd. */
- (instancetype)initWithActivitySheet:(MWActivityViewController *)activitySheet;

/** Returns whether or not an action will be performed when you try to present the activity sheet.
 @return NO if the user has no applications installed capable of handling the action. Otherwise YES. */
- (BOOL)canPerformActivity;

/** Removes the active `MWActivityViewController` from view. */
- (void)dismissActivitySheet;

/** Present the current activity sheet modally on a given view controller.
 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController.

 @warning If your app is either Universal or iPad-only, you should instead use presentModalActivitySheetFromViewController:popoverFromRect:inView:permittedArrowDirections: or presentModalActivitySheetFromViewController:popoverFromBarButtonItem:permittedArrowDirections: instead.
*/
- (void)presentModalActivitySheetFromViewController:(UIViewController *)presentingViewController;

/** Present the current activity sheet on the given view controller. If the device is an iPhone, it will be presented modally; if an iPad, it will be presented in a UIPopoverController with the given options. 
 
 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController.
 @param rect The CGRect the UIPopoverController should be originating from.
 @param view The UIView the UIPopoverController should be displayed in.
 @param arrowDirections A bitmask of permitted arrow directions.
 @param animated Whether or not to animate the popover.

 @see UIPopoverController presentPopoverFromRect:inView:permittedArrowDirections:animated: */
- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController
                               popoverFromRect:(CGRect)rect
                                        inView:(UIView *)view
                      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                      animated:(BOOL)animated;

/** Present the current activity sheet on the given view controller. If the device is an iPhone, it will be presented modally; if an iPad, it will be presented in a UIPopoverController with the given options.

 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController.
 @param item A UIBarButtonItem to originate the UIPopoverController from
 @param arrowDirections A bitmask of permitted arrow directions.
 @param animated Whether or not to animate the popover.

 @see UIPopoverController presentPopoverFromRect:inView:permittedArrowDirections:animated: */
- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController
                      popoverFromBarButtonItem:(UIBarButtonItem *)item
                      permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                      animated:(BOOL)animated;

@end
