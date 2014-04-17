//
//  INKOpenInActivity.m
//  Pods
//
//  Created by Michael Walker on 4/17/14.
//
//

#import "INKOpenInActivity.h"
#import "INKLocalizedString.h"
#import "INKBrowserHandler.h"
#import "IntentKit.h"

@interface INKOpenInActivity ()
@property (strong, nonatomic) NSURL *url;
@end

@implementation INKOpenInActivity

- (NSString *)activityType {
    return @"IntentKit";
}

- (NSString *)activityTitle {
    return INKLocalizedString(@"INKOpenInActivityName", nil);
}

- (UIImage *)activityImage {
    return [IntentKit.sharedInstance imageNamed:@"share"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return (activityItems.count == 1 && [activityItems[0] isKindOfClass:NSURL.class]);
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.url = activityItems[0];
}

- (void)performActivity {
    INKBrowserHandler *handler = [INKBrowserHandler new];
    handler.alwaysShowActivityView = YES;
    handler.showFirstPartyApp = YES;
    handler.disableSettingDefault = YES;
    handler.disableInAppOption = YES;
    handler.showFirstPartyApp = YES;

    [[handler openURL:self.url] presentModally];
}

@end
