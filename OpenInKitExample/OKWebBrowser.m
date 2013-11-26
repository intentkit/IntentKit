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
        NSString *urlString = [dict[@"scheme"] stringByAppendingString:@"://"];
        if ([self.application canOpenURL:[NSURL URLWithString:urlString]]) {
            [availableApps addObject:dict];
        }
    }

    if (availableApps.count == 1) {
        NSDictionary *dict = availableApps[0];
        NSString *string = [NSString stringWithFormat:@"%@:%@",
                            dict[@"scheme"],
                            [NSString stringWithFormat:dict[@"OpenURL:"], url.resourceSpecifier]];
        [self.application openURL:[NSURL URLWithString:string]];
    } else {
        NSMutableArray *activities = [NSMutableArray array];
        for (NSDictionary *dict in availableApps) {
            OKActivity *activity = [[OKActivity alloc] initWithDictionary:dict
                                                              application:self.application];
            [activities addObject:activity];
        }

        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:[activities copy]];

        activityView.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToTwitter, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];

        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:activityView animated:YES completion:nil];
    }
}

@end
