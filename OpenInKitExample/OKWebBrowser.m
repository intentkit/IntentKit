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
    [self.application openURL:url];
}

@end
