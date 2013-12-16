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
    return [self performCommand:command withArguments:args fallback:NO];
}

- (MWActivityPresenter *)performCommand:(NSString *)command withArguments:(NSDictionary *)args fallback:(BOOL)fallback {
    if (!args) { args = @{}; }

    NSMutableArray *availableApps = [NSMutableArray array];
    for (MWActivity *activity in self.appList.activities) {
        if ([activity canPerformCommand:command]) {
            [availableApps addObject:activity];
        }
    }

    if (fallback && [availableApps count] < 1) {
        for (MWActivity *activity in self.appList.activities) {
            NSString *value = [[activity fallbackUrls] valueForKey:command];
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
                NSString *strippedUrl = [url.resourceSpecifier stringByReplacingOccurrencesOfString:@"//" withString:@"" options:0 range:NSMakeRange(0, 2)];
                NSDictionary *newArgs = @{@"url": strippedUrl};
                NSString *newCommand = ([url.scheme isEqualToString:@"https"] ? @"openHttpsURL:" : @"openHttpURL:");

                return [self performCommand:newCommand withArguments:newArgs];
            }
        }
    }

    NSArray *activityItems = @[command, args];

    MWActivityViewController *activityView = [[MWActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:[availableApps copy]];
    return [[MWActivityPresenter alloc] initWithActivitySheet:activityView];
}
@end
