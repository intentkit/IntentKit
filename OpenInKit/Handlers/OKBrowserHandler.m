#import "OKBrowserHandler.h"
#import "OKActivity.h"

@implementation OKBrowserHandler

+ (NSString *)directoryName {
    return @"Web Browsers";
}

- (UIActivityViewController *)openURL:(NSURL *)url {
    NSString *strippedUrl = [url.resourceSpecifier stringByReplacingOccurrencesOfString:@"//" withString:@"" options:0 range:NSMakeRange(0, 2)];
    NSDictionary *args = @{@"url": strippedUrl};

    NSString *command = ([url.scheme isEqualToString:@"https"] ?
                         @"openHttpsURL:" : @"openHttpURL:");

    return [self performCommand:command withArguments:args];
}

- (UIActivityViewController *)openURL:(NSURL *)url withCallback:(NSURL *)callback {
    NSString *command = NSStringFromSelector(_cmd);

    NSString *appName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *targetURL = urlEncode(url.absoluteString);
    NSString *callbackURL = urlEncode(callback.absoluteString);
    NSDictionary *args = @{@"url": targetURL,
                           @"callback": callbackURL,
                           @"source": appName};

    return [self performCommand:command withArguments:args];
}
@end
