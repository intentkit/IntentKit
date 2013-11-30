#import "OKHandler.h"
#import "OKActivity.h"

NSString *(^urlEncode)(NSString *) = ^NSString *(NSString *input){
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    kCFAllocatorDefault,
                                                                    (CFStringRef)input,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    kCFStringEncodingUTF8);
    return (__bridge NSString *)urlString;
};

@implementation OKHandler

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

- (void)performCommand:(NSString *)command withArguments:(NSDictionary *)args {
    NSMutableArray *availableApps = [NSMutableArray array];
    NSArray *appPaths = [NSBundle.mainBundle pathsForResourcesOfType:@".plist"
                                                         inDirectory:self.class.directoryName];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        OKActivity *activity = [[OKActivity alloc] initWithDictionary:dict
                                                          application:self.application];

        if ([activity isAvailableForCommand:command arguments:args]) {
            [availableApps addObject:activity];
        }
    }

    NSArray *activityItems = @[command, args];

    if (availableApps.count == 1) {
        [availableApps[0] prepareWithActivityItems:activityItems];
        [availableApps[0] performActivity];
    } else {
        UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                                  initWithActivityItems:activityItems
                                                  applicationActivities:[availableApps copy]];

        activityView.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];

        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:activityView animated:YES completion:nil];
    }

}
@end
