//
//  INKWebViewController.m
//  Pods
//
//  Created by Michael Walker on 4/16/14.
//
//

#import "INKWebViewController.h"
#import "IntentKit.h"
#import "INKOpenInActivity.h"

@interface INKWebViewController ()<UIWebViewDelegate, UIPopoverControllerDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (assign, nonatomic) BOOL networkIndicatorWasVisible;
@property (strong, nonatomic) NSURL *initialURL;

@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *forwardButton;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *shareButton;

@property (strong, nonatomic) UIPopoverController *popover;
@end

@implementation INKWebViewController

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.delegate = self;

    self.title = @"Loading...";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didTapDoneButton)];

    UIToolbar *toolbar = [self setUpToolbar];
    [self.view addSubview:toolbar];

    NSDictionary *views = @{@"webView":self.webView,
                            @"toolbar":toolbar};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[toolbar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView][toolbar(==44)]|" options:0 metrics:nil views:views]];

    return self;
}

- (void)loadURL:(NSURL *)url {
    self.initialURL = url;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - private

- (UIToolbar *)setUpToolbar {
    UIToolbar *toolbar = [UIToolbar new];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;

    self.backButton = [[UIBarButtonItem alloc] initWithImage:[IntentKit.sharedInstance imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[IntentKit.sharedInstance imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapForwardButton)];
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefreshButton)];
    self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didTapShareButton)];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    toolbar.items = @[fixed, self.backButton, flexible, self.forwardButton, flexible, self.refreshButton, flexible, self.shareButton, fixed];

    self.forwardButton.enabled = NO;
    self.backButton.enabled = NO;

    return toolbar;
}

#pragma mark -
- (void)didTapDoneButton {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)didTapBackButton {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)didTapForwardButton {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }

}

- (void)didTapRefreshButton {
    [self.webView reload];
}

- (void)didTapShareButton {
    INKOpenInActivity *openIn = [INKOpenInActivity new];

    UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:@[openIn]];

    if (IntentKit.sharedInstance.isPad) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:shareSheet];
        [self.popover presentPopoverFromBarButtonItem:self.shareButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.popover.delegate = self;
    } else {
        [self presentViewController:shareSheet animated:YES completion:nil];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    if (!self.networkIndicatorWasVisible) {
        UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
        self.networkIndicatorWasVisible = NO;
    }

    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.networkIndicatorWasVisible = UIApplication.sharedApplication.networkActivityIndicatorVisible;
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popover = nil;
}

#pragma mark - Private
- (NSURL *)url {
    NSURL *webViewURL = self.webView.request.URL;
    if ([webViewURL.absoluteString isEqualToString:@""]) {
        return self.initialURL;
    } else {
        return webViewURL;
    }
}
@end
