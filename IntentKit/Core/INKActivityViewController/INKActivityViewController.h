//
//  INKActivityViewController.h
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INKActivityPresenter;
@class INKActivity;

/** A delegate object responsible for registering defaults. */
@protocol INKActivityViewControllerDefaultsDelegate
/** Register the given activity as a default application.
 @param activity An INKActivity object representing an application
 @warning It is assumed the delegate (typically an `INKHandler`) is responsible for maintaining the stateful knowledge of which handler this is for. */
- (void)addDefault:(INKActivity *)activity;

/** If NO, the toggle view will be hidden.
 
 This is used when the user's preferred app for a handler cannot perform the task they're trying to do; we don't want them to try to register a secondary default. */
- (BOOL)canSetDefault;
@end


/** A re-implementation of `UIActivityViewController`, designed to allow for UIActivity objects with custom full-color images.
 
 This is not a drop-in replacement for `UIActivityViewController`, as it requires the use of a `INKActivityPresenter` helper object to coordinate getting the animation just right. */
@interface INKActivityViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

/** If true, tapping an app will not perform its action, but only set the default. It will also hide the 'set default' toggle bar. */
@property (assign, nonatomic) BOOL isDefaultSelector;

/** The number of applications on the current device capable of handling the action */
@property (readonly) NSInteger numberOfApplications;

/** A presenter object responsible for displaying and hiding the view controller */
@property (strong, nonatomic) INKActivityPresenter *presenter;

/** A delegate responsible for registering defaults */
@property (strong, nonatomic) id<INKActivityViewControllerDefaultsDelegate>delegate;

/** The actual content of the action sheet */
@property (strong, nonatomic) UIView *contentView;

/** The constructor has the same signature as that of `UIActivityViewController`.
 
 @param activityItems An array of items to share
 @param applicationActivities An array of UIActivity objects to display.
 @return An initialized `INKActivityPresenter` object.

 @warning Unlike `UIActivityViewController`, *only* the UIActivity objects specified in the `applicationActivities` array will be displayed; it will not show any of the default activities. */
- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities;

@end
