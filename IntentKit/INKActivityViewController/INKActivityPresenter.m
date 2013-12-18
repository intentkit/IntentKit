//
//  INKActivityPresenter.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/10/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKActivityPresenter.h"
#import "INKActivityViewController.h"
#import "UIView+Helpers.h"
#import "IntentKit.h"

@interface INKActivityPresenter ()

@property (weak, nonatomic) UIViewController *presentingViewController;
@property (strong, nonatomic) UIView *shadeView;
@property (strong, nonatomic) UIPopoverController *popoverController;
@end

@implementation INKActivityPresenter

- (instancetype)initWithActivitySheet:(INKActivityViewController *)activitySheet {
    if (self = [super init]) {
        self.activitySheet = activitySheet;
        self.activitySheet.presenter = self;
    }
    return self;
}

- (instancetype)initWithActivity:(INKActivity *)activity {
    if (self = [super init]) {
        self.activity = activity;
    }
    return self;
}

- (BOOL)canPerformActivity {
    return self.activity || self.activitySheet.numberOfApplications > 1;
}

- (void)presentModalActivitySheetFromViewController:(UIViewController *)presentingViewController {

    if (self.activity) {
        [self.activity performActivity];
    } else if (self.activitySheet) {
        self.presentingViewController = presentingViewController;

        self.shadeView = [[UIView alloc] initWithFrame:self.presentingViewController.view.bounds];
        self.shadeView.backgroundColor = [UIColor blackColor];
        [self.presentingViewController.view addSubview:self.shadeView];

        presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [presentingViewController presentViewController:self.activitySheet animated:NO completion:nil];

        self.shadeView.alpha = 0;
        CGPoint activitySheetOrigin = self.activitySheet.contentView.frame.origin;
        [self.activitySheet.contentView moveToPoint:CGPointMake(self.presentingViewController.view.left, self.presentingViewController.view.bottom)];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
            self.shadeView.alpha = 0.4;
            [self.activitySheet.contentView moveToPoint:activitySheetOrigin];
        } completion:nil];
    }
}

- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController popoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {

    if (self.activity) {
        [self.activity performActivity];
    } else if (IntentKit.sharedInstance.isPad && self.activitySheet) {
        self.presentingViewController = presentingViewController;
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.activitySheet];
        self.popoverController.popoverContentSize = self.activitySheet.view.bounds.size;
        [self.popoverController presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
    } else {
        [self presentModalActivitySheetFromViewController:presentingViewController];
    }
}

- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController popoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {

    if (self.activity) {
        [self.activity performActivity];
    } else if (IntentKit.sharedInstance.isPad && self.activitySheet) {
        self.presentingViewController = presentingViewController;
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.activitySheet];
        [self.popoverController presentPopoverFromBarButtonItem:item  permittedArrowDirections:arrowDirections animated:animated];
    } else {
        [self presentModalActivitySheetFromViewController:presentingViewController];
    }
}

- (void)dismissActivitySheet {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.shadeView.alpha = 0;
        [self.activitySheet.view moveToPoint:CGPointMake(self.presentingViewController.view.left, self.presentingViewController.view.bottom)];
    } completion:^(BOOL finished){
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}
@end
