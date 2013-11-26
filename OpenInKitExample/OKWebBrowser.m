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
    [self openHttpUrl:url];
}

#pragma mark - Private


- (void)openHttpUrl: (NSURL *)url {
    NSString *strippedUrl = [url.resourceSpecifier stringByReplacingOccurrencesOfString:@"//" withString:@"" options:0 range:NSMakeRange(0, 2)];

    NSMutableArray *availableApps = [NSMutableArray array];
    NSArray *appPaths = [NSBundle.mainBundle pathsForResourcesOfType:@".plist"
                                                         inDirectory:@"Web Browsers"];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        OKActivity *activity = [[OKActivity alloc] initWithDictionary:dict
                                                          application:self.application];

        if ([activity isAvailableForCommand:_cmd arguments:@[strippedUrl]]) {
            [availableApps addObject:activity];
        }
    }

    NSArray *activityItems = @[NSStringFromSelector(_cmd), strippedUrl];

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
