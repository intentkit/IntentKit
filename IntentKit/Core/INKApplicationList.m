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

static NSString * const FirstPartyAppNameKey = @"firstPartyAppName";

@interface INKApplicationList ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation INKApplicationList

+ (NSArray *)availableHandlers {
    NSMutableArray *results = [NSMutableArray new];

    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 ) {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
    }

    for (int i = 0; i < numClasses; i++) {
        Class c = classes[i];
        if (class_getSuperclass(c) == [INKHandler class]) {
            [results addObject:c];
        }
    }

    free(classes);
    return [results copy];
}

- (id)initWithApplication:(UIApplication *)application forHandler:(Class)handlerClass {
    if (self = [super init]) {
        self.application = application;
        self.handlerClass = handlerClass;
        self.hideFirstPartyApp = !!self.handlerDefaults[FirstPartyAppNameKey];
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

        NSDictionary *names;
        if ([dict[@"name"] isKindOfClass:[NSString class]]) {
            names = @{@"en": dict[@"name"]};
        } else {
            names = dict[@"name"];
        }

        INKActivity *activity;
        if (dict[@"className"]) {
            Class presenterClass = NSClassFromString(dict[@"className"]);
            NSString *internalName = dict[@"internalName"] ?: dict[@"className"];
            if (!self.hideInApp && [presenterClass conformsToProtocol:@protocol(INKPresentable)]) {
                activity = [[INKActivity alloc] initWithPresenter:[presenterClass new]
                                                          actions:dict[@"actions"]
                                                     internalName:internalName
                                                            names:names
                                                      application:self.application
                                                           bundle:bundle];
            }
        } else if (!(self.hideFirstPartyApp && [names[@"en"] isEqualToString:self.handlerDefaults[FirstPartyAppNameKey]])) {
            activity = [[INKActivity alloc] initWithActions:dict[@"actions"]
                                             optionalParams:dict[@"optional"]
                                                      names:names
                                                application:self.application
                                                     bundle: bundle];
        }

        if (activity) [activities addObject:activity];
    }
    return [activities copy];
}

- (NSArray *)availableActivities {
    NSMutableArray *availableActivities = [NSMutableArray new];
    for (INKActivity *activity in self.activities) {
        if (activity.isAvailableOnDevice) {
            [availableActivities addObject:activity];
        }
    }
    return [availableActivities copy];
}

- (INKActivity *)activityWithName:(NSString *)name {
    for (INKActivity *activity in self.activities) {
        if ([activity.name isEqualToString:name]) {
            return activity;
        }
    }
    return nil;
}

- (BOOL)canUseFallback {
    return !!self.handlerDefaults[@"fallbackUrls"];
}

- (NSString *)fallbackUrlForCommand:(NSString *)command {
    return self.handlerDefaults[@"fallbackUrls"][command];
}

- (NSDictionary *)handlerDefaults {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit-Defaults" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }

    NSString *path = [bundle pathForResource:NSStringFromClass(self.handlerClass) ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
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
