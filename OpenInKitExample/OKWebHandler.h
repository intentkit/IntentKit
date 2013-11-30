#import "OKHandler.h"

@interface OKWebHandler : OKHandler

- (void)openURL:(NSURL *)url;
- (void)openURL:(NSURL *)url withCallback:(NSURL *)callback;

@end
