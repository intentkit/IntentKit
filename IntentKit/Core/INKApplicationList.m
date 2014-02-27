//
//  INKApplicationList.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/8/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKApplicationList.h"
#import "INKActivity.h"
#import "INKHandler.h"

#import <objc/runtime.h>

@interface INKApplicationList ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation INKApplicationList

- (id)initWithApplication:(UIApplication *)application forHandler:(Class)handlerClass {
    if (self = [super init]) {
        self.application = application;
        self.handlerClass = handlerClass;
    }
    return self;
}

- (instancetype)initWithHandler:(Class)handlerClass {
    return [self initWithApplication:[UIApplication sharedApplication] forHandler:handlerClass];
}

- (NSArray *)activities {
    NSMutableArray *activities = [[NSMutableArray alloc] init];

    NSBundle *bundle = [self bundleForCurrentHandler];

    NSArray *appPaths = [bundle pathsForResourcesOfType:@".plist"
                                            inDirectory:nil];

    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        if (!(dict[@"actions"] && dict[@"name"])) { continue; }

        if ([dict[@"name"] isKindOfClass:[NSDictionary class]]) {
            [activities addObject:[[INKActivity alloc] initWithActions:dict[@"actions"]
                                                        optionalParams:dict[@"optional"]
                                                                  names:dict[@"name"]
                                                           application:self.application
                                                                bundle: bundle]];
        } else {
            [activities addObject:[[INKActivity alloc] initWithActions:dict[@"actions"]
                                                        optionalParams:dict[@"optional"]
                                                                  name:dict[@"name"]
                                                           application:self.application
                                                                bundle: bundle]];
        }
    }
    return [activities copy];
}

- (NSString *)fallbackUrlForCommand:(NSString *)command {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit-INKBrowserHandler" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }

    NSString *path = [bundle pathForResource:NSStringFromClass(self.handlerClass) ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

    return dict[@"fallbackUrls"][command];
}

- (NSBundle *)bundleForCurrentHandler {
    NSString *resourceName = [NSString stringWithFormat:@"IntentKit-%@", NSStringFromClass(self.handlerClass)];
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }

    if (!bundle) {
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
        if (bundleURL) {
            bundle = [NSBundle bundleWithURL:bundleURL];
        }
    }

    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    return bundle;
}
@end
