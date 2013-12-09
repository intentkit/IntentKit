//
//  MWActivityViewController.h
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWActivityPresenter;

/** A re-implementation of `UIActivityViewController`, designed to allow for UIActivity objects with custom full-color images.
 
 This is not a drop-in replacement for `UIActivityViewController`, as it requires the use of a `MWActivityPresenter` helper object to coordinate getting the animation just right. */
@interface MWActivityViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

/** A presenter object responsible for displaying and hiding the view controller */
@property (strong, nonatomic) MWActivityPresenter *presenter;

/** The actual content of the action sheet */
@property (strong, nonatomic) UIView *contentView;

/** The constructor has the same signature as that of `UIActivityViewController`.
 
 @param activityItems An array of items to share
 @param applicationActivities An array of UIActivity objects to display.
 
 @warning Unlike `UIActivityViewController`, *only* the UIActivity objects specified in the `applicationActivities` array will be displayed; it will not show any of the default activities. */
- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities;

@end
