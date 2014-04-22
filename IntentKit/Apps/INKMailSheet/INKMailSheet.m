//
//  INKMailSheet.m
//  Pods
//
//  Created by Michael Walker on 4/15/14.
//
//

#import "INKMailSheet.h"
#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>

static char AssociatedObjectKey;

@interface INKMailSheet ()<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) MFMailComposeViewController *controller;
@property (strong, nonatomic) UIViewController *presentingViewController;
@end

@implementation INKMailSheet

- (BOOL)canPerformAction:(NSString *)action {
    return [MFMailComposeViewController canSendMail];
}

- (void)performAction:(NSString *)action
               params:(NSDictionary *)params
     inViewController:(UIViewController *)presentingViewController {

    self.presentingViewController = presentingViewController;

    self.controller = [[MFMailComposeViewController alloc] init];
    self.controller.mailComposeDelegate = self;

    if (params[@"recipient"]) {
        [self.controller setToRecipients:@[params[@"recipient"]]];
    }

    if (params[@"subject"]) {
        [self.controller setSubject:params[@"subject"]];
    }

    if (params[@"messageBody"]) {
        [self.controller setMessageBody:params[@"messageBody"] isHTML:NO];
    }

    [presentingViewController presentViewController:self.controller animated:YES completion:nil];

    // The mail controller only holds a weak reference to this object, and it
    // will be released prior to its delegate method to being called.
    //
    // An associated object is (sadly) the easiest way to ensure the lifecycle of
    // this helper class is exactly as long as the MFMailComposeViewController.
    objc_setAssociatedObject(self.controller, &AssociatedObjectKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    objc_setAssociatedObject(self.presentingViewController, &AssociatedObjectKey, nil, OBJC_ASSOCIATION_ASSIGN);
}
@end
