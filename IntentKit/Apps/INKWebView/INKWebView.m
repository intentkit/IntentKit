//
//  INKWebView.m
//  Pods
//
//  Created by Michael Walker on 4/16/14.
//
//

#import "INKWebView.h"
#import "INKWebViewController.h"

@implementation INKWebView

- (BOOL)canPerformAction:(NSString *)action {
    return YES;
}

- (void)performAction:(NSString *)action
               params:(NSDictionary *)params
     inViewController:(UIViewController *)presentingViewController {

    NSString *urlString;
    if ([action isEqualToString:@"openHttpURL:"]) {
        urlString = @"http://";
    } else if ([action isEqualToString:@"openHttpsURL:"]) {
        urlString = @"https://";
    } else {
        return;
    }
    urlString = [urlString stringByAppendingString:params[@"url"]];
    NSURL *url = [NSURL URLWithString:urlString];

    INKWebViewController *controller = [INKWebViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller loadURL:url];

    controller.closeBlock = ^{
        [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    };

    [presentingViewController presentViewController:navController animated:YES completion:nil];
}

@end
