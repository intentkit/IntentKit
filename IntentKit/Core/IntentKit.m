//
//  IntentKit.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/10/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "IntentKit.h"

@implementation IntentKit

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (BOOL)isPad {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSArray *)preferredLanguages {
    return [NSLocale preferredLanguages];
}

- (UIViewController *)visibleViewController {
    UIViewController *viewController = UIApplication.sharedApplication.delegate.window.rootViewController;
    return [self topViewController:viewController];
}

- (UIViewController *)topViewController:(UIViewController *)parent {
    if (parent.presentedViewController) {
        return [self topViewController:parent.presentedViewController];
    }

    if ([parent isKindOfClass:UINavigationController.class]) {
        return [self topViewController:[(UINavigationController*)parent topViewController]];
    }

    if ([parent isKindOfClass:UITabBarController.class]) {
        return [self topViewController:[(UITabBarController*)parent selectedViewController]];
    }

    return parent;
}

- (UIImage *)imageNamed:(NSString *)name {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle  = [NSBundle bundleWithURL:bundleURL];
    }
    NSString *filename = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:filename];
}
@end
