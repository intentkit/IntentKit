//
//  INKTweetSheet.m
//  Pods
//
//  Created by Michael Walker on 4/21/14.
//
//

#import "INKTweetSheet.h"
#import <Social/Social.h>
#import <objc/runtime.h>

@interface INKTweetSheet ()
@property (strong, nonatomic) SLComposeViewController *controller;
@property (strong, nonatomic) UIViewController *presentingViewController;
@end

@implementation INKTweetSheet

- (BOOL)canPerformAction:(NSString *)action {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)performAction:(NSString *)action
               params:(NSDictionary *)params
     inViewController:(UIViewController *)presentingViewController {

    self.presentingViewController = presentingViewController;

    self.controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

    if (params[@"message"]) {
        [self.controller setInitialText:params[@"message"]];
    }

    [presentingViewController presentViewController:self.controller animated:YES completion:nil];
}

@end
