//
//  INKHandler.m
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKHandler.h"
#import "INKActivity.h"
#import "INKApplicationList.h"
#import "INKActivityViewController.h"
#import "INKActivityPresenter.h"
#import "INKDefaultsManager.h"
#import "INKBrowserHandler.h"

@interface INKHandler ()
@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) INKApplicationList *appList;
@property (strong, nonatomic) INKDefaultsManager *defaultsManager;
@end

NSString *(^urlEncode)(NSString *) = ^NSString *(NSString *input){
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    kCFAllocatorDefault,
                                                                    (CFStringRef)input,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    kCFStringEncodingUTF8);
    return (__bridge NSString *)urlString;
};

@implementation INKHandler

- (instancetype)init {
    if (self = [super init]) {
        self.application = [UIApplication sharedApplication];
        self.appList = [[INKApplicationList alloc] initWithApplication:self.application];
        self.defaultsManager = [[INKDefaultsManager alloc] init];
    }

    return self;
}

- (BOOL)canPerformCommand:(NSString *)command {
    BOOL canPerform = NO;
    for (INKActivity *activity in self.appList.activities) {
        canPerform = canPerform || [activity canPerformCommand:command];
    }

    return canPerform;
}

- (INKActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args {
    return [self performCommand:command withArguments:args fallback:NO];
}

- (INKActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args fallback:(BOOL)fallback {
    if (!args) { args = @{}; }

    NSMutableArray *availableApps = [NSMutableArray array];
    for (INKActivity *activity in self.appList.activities) {
        if ([activity canPerformCommand:command]) {
            [availableApps addObject:activity];
        }
    }

    if (fallback && [availableApps count] < 1) {
        for (INKActivity *activity in self.appList.activities) {
            NSString *value = [self fallbackUrl:command];
            if (value) {
                NSMutableArray *searchStrings = [[NSMutableArray alloc] init];
                for (NSString *str in [args allKeys]) {
                    [searchStrings addObject:[NSString stringWithFormat:@"%@%@%@", @"{", str, @"}"]];
                }

                NSMutableArray *replaceStrings = [[NSMutableArray alloc] init];
                for (NSString *str in [args allValues]) {
                    [replaceStrings addObject:str];
                }

                for (NSUInteger i = 0; i < [replaceStrings count]; i++) {
                    value = [value stringByReplacingOccurrencesOfString:[searchStrings objectAtIndex:i] withString:[replaceStrings objectAtIndex:i]];
                }

                NSURL *url = [NSURL URLWithString:value];
                INKBrowserHandler *browserHandler = [[INKBrowserHandler alloc] init];
                return [browserHandler openURL:url];
            }
        }
    }

    NSArray *activityItems = @[command, args];

    if (!self.alwaysShowActivityView) {
        INKActivity *app;

        if (availableApps.count == 1) {
            app = availableApps.firstObject;
        } else if (self.defaultAppName) {
            NSString *appName = self.defaultAppName;
            for (INKActivity *theApp in availableApps) {
                if ([theApp.name isEqualToString:appName]) {
                    app = theApp;
                    break;
                }
            }
        }

        if (app) {
            [app prepareWithActivityItems:activityItems];
            return [[INKActivityPresenter alloc] initWithActivity:app];
        }
    }

    INKActivityViewController *activityView = [[INKActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:[availableApps copy]];
    activityView.delegate = self;
    return [[INKActivityPresenter alloc] initWithActivitySheet:activityView];
}

#pragma mark - INKActivityViewControllerDefaultsDelegate methods
- (void)addDefault:(INKActivity *)activity {
    [self.defaultsManager addDefault:activity.name forHandler:self.class];
}

- (BOOL)canSetDefault {
    return !(BOOL)self.defaultAppName;
}

#pragma mark - Private methods
- (NSString *)defaultAppName {
    return [self.defaultsManager defaultApplicationForHandler:self.class];
}

- (NSString *)fallbackUrl:(NSString *)command {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }

    NSArray *appPaths = [bundle pathsForResourcesOfType:@".plist"
                                            inDirectory:nil];
    for (NSString *path in appPaths) {
        if ([path.lastPathComponent hasPrefix:@"INK"]) {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path][@"fallbackUrls"];

            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dict valueForKey:command]) {
                    return [dict valueForKey:command];
                }
            }
        }
    }

    return nil;
}
@end
