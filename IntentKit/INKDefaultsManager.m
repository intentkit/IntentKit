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

- (NSString *)defaultApplicationForHandler:(Class)handlerClass {
    NSDictionary *dict = [NSUserDefaults.standardUserDefaults objectForKey:INKDefaultsManagerUserDefaultsKey];
    return dict[NSStringFromClass(handlerClass)];
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
