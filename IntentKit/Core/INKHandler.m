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

@implementation INKHandler

- (instancetype)init {
    if (self = [super init]) {
        self.application = [UIApplication sharedApplication];
        self.appList = [[INKApplicationList alloc] initWithApplication:self.application forHandler:self.class];
        self.defaultsManager = [[INKDefaultsManager alloc] init];
        self.useFallback = YES;
    }

    return self;
}

+ (INKHandlerCategory)category {
    return INKHandlerCategoryUnknown;
}

+ (NSString *)name {
    @throw @"Method not implemented";
}

- (NSString *)defaultApp {
    return [self.defaultsManager defaultApplicationForHandler:self.class
                                           allowSystemDefault:self.useSystemDefault];
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
        NSString *fallbackUrl = [self.appList fallbackUrlForCommand:command];
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
        } else if (self.defaultApp) {
            NSString *appName = self.defaultApp;
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

- (INKActivityPresenter *)promptToSetDefault {
    NSMutableArray *activities = [NSMutableArray new];
    for (INKActivity *activity in self.appList.activities) {
        if (activity.isAvailableOnDevice) {
            [activities addObject:activity];
        }
    }

    INKActivityViewController *activityView = [[INKActivityViewController alloc] initWithActivityItems:@[] applicationActivities:activities];
    activityView.delegate = self;
    activityView.isDefaultSelector = YES;
    return [[INKActivityPresenter alloc] initWithActivitySheet:activityView];
}

- (void)setShowFirstPartyApp:(BOOL)showFirstPartyApp {
    _showFirstPartyApp = showFirstPartyApp;
    self.appList.hideFirstPartyApp = !showFirstPartyApp;
}

- (void)setDisableInAppOption:(BOOL)disableInAppOption {
    _disableInAppOption = disableInAppOption;
    self.appList.hideInApp = disableInAppOption;
}

#pragma mark - INKActivityViewControllerDefaultsDelegate methods
- (void)addDefault:(INKActivity *)activity {
    [self.defaultsManager addDefault:activity.name forHandler:self.class];
}

- (BOOL)canSetDefault {
    return (self.defaultApp == nil) && !self.disableSettingDefault;
}
@end
