//
//  INKWebViewController.m
//  Pods
//
//  Created by Michael Walker on 4/16/14.
//
//

#import "INKWebViewController.h"

@interface INKWebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (assign, nonatomic) BOOL networkIndicatorWasVisible;
@end

@implementation INKWebViewController

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.view = self.webView;
    self.webView.delegate = self;

    self.title = @"Loading...";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapDoneButton)];

    return self;
}

- (void)loadURL:(NSURL *)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark -
- (void)didTapDoneButton {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.networkIndicatorWasVisible) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
        self.networkIndicatorWasVisible = NO;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.networkIndicatorWasVisible = UIApplication.sharedApplication.networkActivityIndicatorVisible;
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
}

@end
