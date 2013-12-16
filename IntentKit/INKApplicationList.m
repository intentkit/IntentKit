//
//  INKApplicationList.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/8/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKApplicationList.h"
#import "INKActivity.h"

@interface INKApplicationList ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation INKApplicationList

- (instancetype)initWithApplication:(UIApplication *)application {
    if (self = [super init]) {
        self.application = application;
    }
    return self;
}

- (instancetype)init {
    return [self initWithApplication:[UIApplication sharedApplication]];
}

- (NSArray *)activities {
    NSMutableArray *activities = [[NSMutableArray alloc] init];

    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }

    NSArray *appPaths = [bundle pathsForResourcesOfType:@".plist"
                                            inDirectory:nil];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];

        if (!(dict[@"actions"] && dict[@"name"])) { continue; }

        if ([dict[@"name"] isKindOfClass:[NSDictionary class]]) {
            [activities addObject:[[INKActivity alloc] initWithActions:dict[@"actions"]
                                                        fallbackUrls:dict[@"fallbackUrls"]
                                                        optionalParams:dict[@"optional"]
                                                                  names:dict[@"name"]
                                                           application:self.application]];
        } else {
            [activities addObject:[[INKActivity alloc] initWithActions:dict[@"actions"]
                                                        fallbackUrls:dict[@"fallbackUrls"]
                                                        optionalParams:dict[@"optional"]
                                                                  name:dict[@"name"]
                                                           application:self.application]];
        }
    }
    return [activities copy];
}

@end
