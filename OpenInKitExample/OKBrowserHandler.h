#import "OKHandler.h"

@interface OKBrowserHandler : OKHandler

- (UIActivityViewController *)openURL:(NSURL *)url;
- (UIActivityViewController *)openURL:(NSURL *)url withCallback:(NSURL *)callback;

@end
