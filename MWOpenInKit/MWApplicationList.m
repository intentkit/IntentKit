//
//  MWApplicationList.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/8/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWApplicationList.h"
#import "MWActivity.h"

@interface MWApplicationList ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation MWApplicationList

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

    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"MWOpenInKit" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }

    NSArray *appPaths = [bundle pathsForResourcesOfType:@".plist"
                                            inDirectory:nil];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString *name = [path.pathComponents.lastObject stringByDeletingPathExtension];

        if ([@[@"Info", @"MWOpenInKitBundle-Info"] containsObject:name]) {
            continue;
        }

        [activities addObject:[[MWActivity alloc] initWithDictionary:dict
                                                                name:name
                                                         application:self.application]];
    }
    return [activities copy];
}

@end
