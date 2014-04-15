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

- (id)initWithAction:(NSString *)action params:(NSDictionary *)params {
    self = [super init];
    if (!self) return nil;
    if (![action isEqualToString:@"sendMailTo:"]) return nil;

    self.controller = [[MFMailComposeViewController alloc] init];
    self.controller.mailComposeDelegate = self;

    [self.controller setToRecipients:@[params[@"recipient"]]];

    if (params[@"subject"]) {
        [self.controller setSubject:params[@"subject"]];
    }

    if (params[@"messageBody"]) {
        [self.controller setMessageBody:params[@"messageBody"] isHTML:NO];
    }

    return self;
}

- (void)presentInViewController:(UIViewController *)presentingViewController {
    self.presentingViewController = presentingViewController;
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
