//
//  INKAppIconView.h
//  IntentKitDemo
//
//  Created by Michael Walker on 2/27/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A view that shows a single image presented as an app icon (i.e. it is masked to an iOS 7-style superellipse and has a border */
@interface INKAppIconView : UIView

/** The UIImage to be displayed. */
@property (strong, nonatomic) UIImage *image;

/** Masks the given image.
 @param completion A completion block whose only argument is the masked UIImage object. */
- (void)maskImageWithCompletion:(void(^)(UIImage *maskedImage))completion;

/** Initialize with a UIImage
 @param image The value to be set on the object's `image` property
 @return A properly instantiated INKAppIconView object. Its size will be set automatically. */
- (id)initWithImage:(UIImage *)image;

@end
