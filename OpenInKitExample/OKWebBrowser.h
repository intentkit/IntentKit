#import <Foundation/Foundation.h>

@interface OKWebBrowser : NSObject

- (void)openURL:(NSURL *)url;
- (void)openURL:(NSURL *)url withCallback:(NSURL *)callback;

@end
