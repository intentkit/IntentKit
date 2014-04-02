//
//  INKDefaultsManager.m
//  IntentKitDemo
//
//  Created by Michael Walker on 12/18/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKDefaultsManager.h"

static NSString * const INKDefaultsManagerUserDefaultsKey = @"IntentKitDefaults";

@implementation INKDefaultsManager

- (NSString *)defaultApplicationForHandler:(Class)handlerClass
                        allowSystemDefault:(BOOL)allowSystemDefault {
    NSDictionary *dict = [NSUserDefaults.standardUserDefaults objectForKey:INKDefaultsManagerUserDefaultsKey];

    NSString *name = dict[NSStringFromClass(handlerClass)];
    if (name) {
        return name;
    } else if (allowSystemDefault) {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit-Defaults" withExtension:@"bundle"];
        NSBundle *bundle;
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }

        NSString *path = [bundle pathForResource:NSStringFromClass(handlerClass) ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        return dict[@"default"];
    }

    return nil;
}

- (void)addDefault:(NSString *)appName forHandler:(Class)handlerClass {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[defaults objectForKey:INKDefaultsManagerUserDefaultsKey] mutableCopy];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }

    dict[NSStringFromClass(handlerClass)] = appName;

    [defaults setObject:dict forKey:INKDefaultsManagerUserDefaultsKey];
    [defaults synchronize];
}

- (void)removeDefaultForHandler:(Class)handlerClass {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [[defaults objectForKey:INKDefaultsManagerUserDefaultsKey] mutableCopy];

    NSString *key = NSStringFromClass(handlerClass);
    if (dict[key]) {
        [dict removeObjectForKey:key];
    }

    [defaults setObject:dict forKey:INKDefaultsManagerUserDefaultsKey];
    [defaults synchronize];
}

- (void)removeAllDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:INKDefaultsManagerUserDefaultsKey];
}

@end