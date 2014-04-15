//
//  UIViewController+Spec.m
//  IntentKitDemo
//
//  Created by Michael Walker on 4/15/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import "UIViewController+Spec.h"
#import <objc/runtime.h>

static char PresentedViewControllerKey;

@implementation UIViewController (Spec)
@dynamic presentedViewController;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    self.presentedViewController = viewControllerToPresent;
    if (completion) completion();
}

- (void)setPresentedViewController:(UIViewController *)presentedViewController {
    objc_setAssociatedObject(self, &PresentedViewControllerKey, presentedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)presentedViewController {
    return objc_getAssociatedObject(self, &PresentedViewControllerKey);
}

#pragma clang diagnostic pop

@end
