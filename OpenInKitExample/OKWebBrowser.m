#import "OKWebBrowser.h"

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
        NSLog(@"================> %@", string);
        [self.application openURL:[NSURL URLWithString:string]];
    } else {
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:nil applicationActivities:nil];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:activityView animated:NO completion:nil];
    }
}

@end
