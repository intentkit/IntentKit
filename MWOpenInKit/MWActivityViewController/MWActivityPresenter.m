//
//  MWActivityPresenter.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/10/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWActivityPresenter.h"
#import "MWActivityViewController.h"
#import "UIView+Helpers.h"

@interface MWActivityPresenter ()

@property (weak, nonatomic) UIViewController *presentingViewController;
@property (strong, nonatomic) UIView *shadeView;

@end

@implementation MWActivityPresenter

- (instancetype)initWithActivitySheet:(MWActivityViewController *)activitySheet {
    if (self = [super init]) {
        self.activitySheet = activitySheet;
        self.activitySheet.presenter = self;
    }
    return self;
}

- (void)presentActivitySheetFromViewController:(UIViewController *)presentingViewController {

    self.presentingViewController = presentingViewController;

    self.shadeView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
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

- (void)dismissActivitySheet {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations: ^{
        self.shadeView.alpha = 0;
        [self.activitySheet.view moveToPoint:CGPointMake(self.presentingViewController.view.left, self.presentingViewController.view.bottom)];
    } completion:^(BOOL finished){
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}
@end
