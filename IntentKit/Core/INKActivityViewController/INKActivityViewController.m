//
//  INKActivityViewController.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKActivityViewController.h"
#import "INKActivityCell.h"
#import "INKActivityPresenter.h"
#import "IntentKit.h"
#import "INKDefaultToggleView.h"
#import "INKLocalizedString.h"

#import <MWLayoutHelpers/UIView+MWLayoutHelpers.h>

static NSString * const CellIdentifier = @"UIActivityCell";

static CGSize const INKActivityViewControllerItemSize_Pad = {80.f, 101.f};
static CGSize const INKActivityViewControllerItemSize_Phone = {70.f, 86.f};

static CGFloat const INKActivityViewControllerRowHeight_Pad = 140.f;
static CGFloat const INKActivityViewControllerRowHeight_Phone = 96.f;

static NSInteger const INKActivityViewControllerItemsPerRow_Phone = 4;
static CGFloat const INKActivityViewControllerWidth_Pad = 403.f;

static UIEdgeInsets const INKActivityViewControllerEdgeInsets_Phone = {20.f, 10.f, 25.f, 10.f};
static UIEdgeInsets const INKActivityViewControllerEdgeInsets_Pad = {16.f, 12.f, 22.f, 12.f};

static CGFloat const INKActivityViewControllerMinimumSpacing_Phone = 5.f;
static CGFloat const INKActivityViewControllerMinimumSpacing_Pad = 10.f;

@interface INKActivityViewController ()
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIToolbar *blurToolbar;
@property (strong, nonatomic) INKDefaultToggleView *defaultToggleView;

@property (strong, nonatomic) NSArray *activityItems;
@property (strong, nonatomic) NSArray *applicationActivities;
@end

@implementation INKActivityViewController

- (instancetype)init {
    @throw @"You cannot instantiate an INKActivityViewController using `init`. Use `initWithActivityItems:applicationActivities:` instead";
}

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    if (self = [super init]) {
        self.activityItems = activityItems;
        self.applicationActivities = applicationActivities;

        if (IntentKit.sharedInstance.isPad) {
            self.contentView = self.view;
        } else {
            self.contentView = [[UIView alloc] init];
            [self.view addSubview:self.contentView];
        }

        [self addDefaultsToggle];
        [self addBlurBackground];

        if (IntentKit.sharedInstance.isPad) {
            [self setUpCollectionViewForPad];
        } else {
            [self setUpCollectionViewForPhone];
            [self addCancelButton];
        }

        [self setBounds];
    }
    return self;
}

- (void)setIsDefaultSelector:(BOOL)isDefaultSelector {
    _isDefaultSelector = isDefaultSelector;
    if (isDefaultSelector) {
        self.defaultToggleView.frame = CGRectZero;
        self.defaultToggleView.hidden = YES;
    }

    [self setBounds];
}

- (NSInteger)numberOfApplications {
    return self.applicationActivities.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL canSetDefault = self.delegate.canSetDefault && !self.isDefaultSelector;
    self.defaultToggleView.enabled = canSetDefault;
    self.defaultToggleView.hidden = !canSetDefault;
    if (!canSetDefault) {
        self.defaultToggleView.frame = CGRectZero;
    }

    [self setBounds];
    self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
}

- (void)configureForPad {
    self.defaultToggleView.frame = CGRectMake(0, 0, self.view.width, self.defaultToggleView.height);

    CGRect frame = CGRectMake(0,
                              0,
                              INKActivityViewControllerWidth_Pad,
                              INKActivityViewControllerRowHeight_Pad + self.defaultToggleView.height);
    self.view.frame = frame;
    self.blurToolbar.frame = self.contentView.bounds;
    self.collectionView.frame = self.view.bounds;
    [self.collectionView moveBy:CGPointMake(0, self.defaultToggleView.height)];
    [self.collectionView resizeTo:CGSizeMake(self.collectionView.width, self.collectionView.height - self.defaultToggleView.height)];
}

- (void)configureForPhone {
    int numberOfRows = ceil((CGFloat)self.applicationActivities.count / INKActivityViewControllerItemsPerRow_Phone);

    self.defaultToggleView.frame = CGRectMake(0, 0, self.view.width, self.defaultToggleView.height);

    CGFloat viewHeight = self.cancelButton.height + self.defaultToggleView.height + self.collectionViewLayout.sectionInset.bottom + numberOfRows * INKActivityViewControllerRowHeight_Phone;

    CGRect frame = CGRectMake(0,
                              self.view.bottom - viewHeight,
                              self.view.width,
                              viewHeight);

    CGRect collectionFrame = self.contentView.bounds;
    collectionFrame.origin.y += self.defaultToggleView.height;
    collectionFrame.size.height -= self.cancelButton.height;
    self.collectionView.frame = collectionFrame;

    self.contentView.frame = frame;
    self.blurToolbar.frame = self.contentView.bounds;

    [self.cancelButton moveToPoint:CGPointMake(0, self.contentView.height - self.cancelButton.height)];

}
- (void)setBounds {
    if (IntentKit.sharedInstance.isPad) {
        [self configureForPad];
    } else {
        [self configureForPhone];
    }
}

- (void)didTapCancelButton {
    [self.presenter dismissActivitySheetAnimated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.applicationActivities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    INKActivityCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.activity = self.applicationActivities[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    INKActivity *activity = self.applicationActivities[indexPath.row];

    if (self.defaultToggleView.isOn || self.isDefaultSelector) {
        [self.delegate addDefault:activity];
    }

    UIViewController *presentingViewController = self.presentingViewController;

    [self.presenter dismissActivitySheetAnimated:NO];

    if (!self.isDefaultSelector) {
        [activity prepareWithActivityItems:self.activityItems];
        [activity performActivityInViewController:presentingViewController];
    }

    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Rendering methods
- (void)addDefaultsToggle {
    self.defaultToggleView = [[INKDefaultToggleView alloc] init];
    [self.contentView addSubview:self.defaultToggleView];
}

- (void)addBlurBackground {
    self.blurToolbar = [[UIToolbar alloc] initWithFrame:self.contentView.bounds];
    [self.contentView insertSubview:self.blurToolbar atIndex:0];
}

- (void)setUpCollectionViewForPhone {
    [self setUpCollectionView];
    self.collectionViewLayout.itemSize = INKActivityViewControllerItemSize_Phone;
    self.collectionViewLayout.sectionInset = INKActivityViewControllerEdgeInsets_Phone;
    self.collectionView.scrollEnabled = NO;
    self.collectionViewLayout.minimumInteritemSpacing = INKActivityViewControllerMinimumSpacing_Phone;
    self.collectionViewLayout.minimumLineSpacing = INKActivityViewControllerMinimumSpacing_Phone;
}

- (void)setUpCollectionViewForPad {
    [self setUpCollectionView];
    self.collectionViewLayout.itemSize = INKActivityViewControllerItemSize_Pad;
    self.collectionViewLayout.sectionInset = INKActivityViewControllerEdgeInsets_Pad;
    self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewLayout.minimumInteritemSpacing = INKActivityViewControllerMinimumSpacing_Pad;
    self.collectionViewLayout.minimumInteritemSpacing = INKActivityViewControllerMinimumSpacing_Pad;
}

- (void)setUpCollectionView {
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    [self.collectionView registerClass:[INKActivityCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.contentView addSubview: self.collectionView];

    self.collectionView.backgroundColor = UIColor.clearColor;
}

- (void)addCancelButton {
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(0, 0, self.view.width, 44.f);
    [self.cancelButton setTitle:INKLocalizedString(@"CancelButtonText", nil) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:24.f];
    self.cancelButton.backgroundColor = UIColor.clearColor;
    [self.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
}

@end
