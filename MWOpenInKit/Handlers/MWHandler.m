//
//  MWHandler.m
//  MWOpenInKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWHandler.h"
#import "MWActivity.h"

@interface MWHandler ()
@property (strong, nonatomic) UIApplication *application;
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

+ (NSString *)directoryName {
    @throw [NSString stringWithFormat:@"%@ needs to overwrite the `directoryName` class method", self];
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        self.application = [UIApplication sharedApplication];
    }

    return self;
}

- (UIActivityViewController *)performCommand:(NSString *)command withArguments:(NSDictionary *)args {
    if (!args) { args = @{}; }

    NSMutableArray *availableApps = [NSMutableArray array];

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

        MWActivity *activity = [[MWActivity alloc] initWithDictionary:dict
                                                                 name: name
                                                          application:self.application];

        if ([activity canPerformCommand:command withArguments:args]) {
            [availableApps addObject:activity];
        }
    }

    NSArray *activityItems = @[command, args];

    if (availableApps.count == 1 && !self.alwaysShowActivityView) {
        [availableApps[0] prepareWithActivityItems:activityItems];
        [availableApps[0] performActivity];
        return nil;
    } else {
        UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                                  initWithActivityItems:activityItems
                                                  applicationActivities:[availableApps copy]];

        activityView.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];

        return activityView;
    }
}
@end
