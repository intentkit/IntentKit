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

/** Instantiate a `MWActivityPresenter` with a given `MWActivityViewController`.
 @param activitySheet The `MWActivityViewController` that will be presentd. */
- (instancetype)initWithActivitySheet:(MWActivityViewController *)activitySheet;

/** Removes the active `MWActivityViewController` from view. */
- (void)dismissActivitySheet;

/** Modally present the current activity sheet as a modal view on a given view controller.
 @param presentingViewController A UIViewController to serve as the activity sheet's presentingViewController. */
- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController;

@end
