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
#import "NSString+Helpers.h"

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
        self.useFallback = YES;
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
    if (!args) { args = @{}; }

    NSMutableArray *availableApps = [NSMutableArray array];
    for (INKActivity *activity in self.appList.activities) {
        if ([activity canPerformCommand:command]) {
            [availableApps addObject:activity];
        }
    }

    if (self.useFallback && [availableApps count] < 1) {
        NSString *fallbackUrl = [self.appList fallbackUrlForHandler:self.class command:command];
        if (fallbackUrl) {
            fallbackUrl = [fallbackUrl stringByEvaluatingTemplateWithData:args];
            NSURL *url = [NSURL URLWithString:fallbackUrl];
            INKBrowserHandler *browserHandler = [[INKBrowserHandler alloc] init];
            return [browserHandler openURL:url];
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
    return (self.defaultAppName == nil);
}

#pragma mark - Private methods
- (NSString *)defaultAppName {
    return [self.defaultsManager defaultApplicationForHandler:self.class];
}
@end
