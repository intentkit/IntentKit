#import "OKHandler.h"

@interface OKBrowserHandler : OKHandler

- (void)openURL:(NSURL *)url;
- (void)openURL:(NSURL *)url withCallback:(NSURL *)callback;

@end
