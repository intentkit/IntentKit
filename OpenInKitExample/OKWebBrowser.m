#import "OKWebBrowser.h"
#import "OKActivity.h"

@interface OKWebBrowser ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation OKWebBrowser

- (instancetype)init {
    if (self = [super init]) {
        self.application = [UIApplication sharedApplication];
    }

    return self;
}

- (void)openURL:(NSURL *)url {
    NSMutableArray *availableApps = [NSMutableArray array];

    NSArray *appPaths = [NSBundle.mainBundle pathsForResourcesOfType:@".plist"
                                                     inDirectory:@"Web Browsers"];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        OKActivity *activity = [[OKActivity alloc] initWithDictionary:dict
                                                          application:self.application];

        if ([activity isAvailable]) {
            [availableApps addObject:activity];
        }
    }

    if (availableApps.count == 1) {
        [availableApps[0] prepareWithActivityItems:@[url]];
        [availableApps[0] performActivity];
    } else {
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:[availableApps copy]];

        activityView.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];

        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:activityView animated:YES completion:nil];
    }
}

@end
