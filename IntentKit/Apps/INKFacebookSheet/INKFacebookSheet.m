//
//  INKFacebookSheet.m
//  Pods
//
//  Created by Michael Walker on 4/21/14.
//
//

#import "INKFacebookSheet.h"
#import <Social/Social.h>
#import <objc/runtime.h>

@interface INKFacebookSheet ()
@property (strong, nonatomic) SLComposeViewController *controller;
@property (strong, nonatomic) UIViewController *presentingViewController;
@end

@implementation INKFacebookSheet

- (BOOL)canPerformAction:(NSString *)action {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
}

- (void)performAction:(NSString *)action
               params:(NSDictionary *)params
     inViewController:(UIViewController *)presentingViewController {

    self.presentingViewController = presentingViewController;

    self.controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

    if (params[@"message"]) {
        [self.controller setInitialText:params[@"message"]];
    }

    [presentingViewController presentViewController:self.controller animated:YES completion:nil];
}

@end
