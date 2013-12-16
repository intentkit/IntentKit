//
//  INKActivityViewController.h
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INKActivityPresenter;

/** A re-implementation of `UIActivityViewController`, designed to allow for UIActivity objects with custom full-color images.
 
 This is not a drop-in replacement for `UIActivityViewController`, as it requires the use of a `INKActivityPresenter` helper object to coordinate getting the animation just right. */
@interface INKActivityViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

/** The number of applications on the current device capable of hadling the action */
@property (readonly) NSInteger numberOfApplications;

/** A presenter object responsible for displaying and hiding the view controller */
@property (strong, nonatomic) INKActivityPresenter *presenter;

/** The actual content of the action sheet */
@property (strong, nonatomic) UIView *contentView;

/** The constructor has the same signature as that of `UIActivityViewController`.
 
 @param activityItems An array of items to share
 @param applicationActivities An array of UIActivity objects to display.
 @return An initialized `INKActivityPresenter` object.

 @warning Unlike `UIActivityViewController`, *only* the UIActivity objects specified in the `applicationActivities` array will be displayed; it will not show any of the default activities. */
- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities;

/** Perform the action in the first available application. If no applications are available to perform the action, this will do nothing. */
- (void)performActivityInFirstAvailableApplication;

@end
