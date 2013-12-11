//
//  MWHandler.m
//  MWOpenInKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWHandler.h"
#import "MWActivity.h"
#import "MWApplicationList.h"
#import "MWActivityViewController.h"
#import "MWActivityPresenter.h"

@interface MWHandler ()
@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) MWApplicationList *appList;
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

@implementation MWHandler

- (instancetype)init {
    if (self = [super init]) {
        self.application = [UIApplication sharedApplication];
        self.appList = [[MWApplicationList alloc] initWithApplication:self.application];
    }

    return self;
}

- (BOOL)canPerformCommand:(NSString *)command {
    BOOL canPerform = NO;
    for (MWActivity *activity in self.appList.activities) {
        canPerform = canPerform || [activity canPerformCommand:command];
    }

    return canPerform;
}

- (MWActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args {
    if (!args) { args = @{}; }

    NSMutableArray *availableApps = [NSMutableArray array];
    for (MWActivity *activity in self.appList.activities) {
        if ([activity canPerformCommand:command]) {
            [availableApps addObject:activity];
        }
    }

    NSArray *activityItems = @[command, args];

    MWActivityViewController *activityView = [[MWActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:[availableApps copy]];
    return [[MWActivityPresenter alloc] initWithActivitySheet:activityView];
}
@end
