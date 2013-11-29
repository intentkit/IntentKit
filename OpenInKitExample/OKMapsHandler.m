#import "OKMapsHandler.h"
#import "OKActivity.h"

@interface OKMapsHandler ()
@property (strong, nonatomic) UIApplication *application;
@end

@implementation OKMapsHandler

- (instancetype)init {
    if (self = [super init]) {
        self.application = [UIApplication sharedApplication];
    }

    return self;
}

- (void)searchFor:(NSString *)query near:(CLLocationCoordinate2D)center {
    NSString *(^encode)(NSString *) = ^NSString *(NSString *input){
        CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                        kCFAllocatorDefault,
                                                                        (CFStringRef)input,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8);
        return (__bridge NSString *)urlString;
    };

    NSString *command = NSStringFromSelector(_cmd);
    NSString *centerString = [NSString stringWithFormat:@"%f,%f", center.latitude, center.longitude];
    NSDictionary *args = @{@"query": encode(query),
                      @"center": centerString};
    NSArray *activityItems = @[command, args];

    NSMutableArray *availableApps = [NSMutableArray array];
    NSArray *appPaths = [NSBundle.mainBundle pathsForResourcesOfType:@".plist"
                                                         inDirectory:@"Maps"];
    for (NSString *path in appPaths) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        OKActivity *activity = [[OKActivity alloc] initWithDictionary:dict
                                                          application:self.application];

        if ([activity isAvailableForCommand:command arguments:args]) {
            [availableApps addObject:activity];
        }
    }

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
