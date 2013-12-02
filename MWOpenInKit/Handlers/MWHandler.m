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
    NSMutableArray *availableApps = [NSMutableArray array];
    NSArray *appPaths = [NSBundle.mainBundle pathsForResourcesOfType:@".plist"
                                                         inDirectory:self.class.directoryName];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString *name = [[[[path componentsSeparatedByString:@"/"] lastObject]
                           componentsSeparatedByString:@"."] firstObject];

        MWActivity *activity = [[MWActivity alloc] initWithDictionary:dict
                                                                 name: name
                                                          application:self.application];

        if ([activity isAvailableForCommand:command arguments:args]) {
            [availableApps addObject:activity];
        }
    }

    NSArray *activityItems = @[command, args];

    if (availableApps.count == 1) {
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
