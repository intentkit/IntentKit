//
//  MWActivityViewController.m
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWActivityViewController.h"
#import "MWActivityCell.h"
#import "UIView+Helpers.h"
#import "MWActivityPresenter.h"
#import "MWOpenInKit.h"

static NSString * const CellIdentifier = @"UIActivityCell";

static CGSize const MWActivityViewControllerItemSize_Pad = {80.f, 101.f};
static CGSize const MWActivityViewControllerItemSize_Phone = {64.f, 86.f};

static CGFloat const MWActivityViewControllerRowHeight_Pad = 140.f;
static CGFloat const MWActivityViewControllerRowHeight_Phone = 96.f;

static NSInteger const MWActivityViewControllerItemsPerRow_Phone = 4;
static CGFloat const MWActivityViewControllerWidth_Pad = 403.f;

static UIEdgeInsets const MWActivityViewControllerEdgeInsets_Phone = {20.f, 10.f, 25.f, 10.f};
static UIEdgeInsets const MWActivityViewControllerEdgeInsets_Pad = {16.f, 12.f, 22.f, 12.f};

static CGFloat const MWActivityViewControllerMinimumSpacing_Phone = 5.f;
static CGFloat const MWActivityViewControllerMinimumSpacing_Pad = 10.f;


@interface MWActivityViewController ()
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIToolbar *blurToolbar;

@property (strong, nonatomic) NSArray *activityItems;
@property (strong, nonatomic) NSArray *applicationActivities;
@end

@implementation MWActivityViewController

- (instancetype)init {
    @throw @"You cannot instantiate an MWActivityViewController using `init`. Use `initWithActivityItems:applicationActivities:` instead";
}

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    if (self = [super init]) {
        UIApplication.sharedApplication.keyWindow.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;

        self.activityItems = activityItems;
        self.applicationActivities = applicationActivities;

        if (MWOpenInKit.isPad) {
            self.contentView = self.view;
        } else {
            self.contentView = [[UIView alloc] init];
            [self.view addSubview:self.contentView];
        }

        self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        [self.collectionView registerClass:[MWActivityCell class] forCellWithReuseIdentifier:CellIdentifier];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;

        [self.contentView addSubview: self.collectionView];

        self.collectionView.backgroundColor = UIColor.clearColor;
        self.blurToolbar = [[UIToolbar alloc] initWithFrame:self.contentView.bounds];
        [self.contentView insertSubview:self.blurToolbar atIndex:0];

        if (MWOpenInKit.isPad) {
            self.collectionViewLayout.itemSize = MWActivityViewControllerItemSize_Pad;
            self.collectionViewLayout.sectionInset = MWActivityViewControllerEdgeInsets_Pad;
            self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        } else {
            self.collectionViewLayout.itemSize = MWActivityViewControllerItemSize_Phone;
            self.collectionViewLayout.sectionInset = MWActivityViewControllerEdgeInsets_Phone;
            self.collectionView.scrollEnabled = NO;
            self.collectionViewLayout.minimumInteritemSpacing = MWActivityViewControllerMinimumSpacing_Phone;
            self.collectionViewLayout.minimumLineSpacing = MWActivityViewControllerMinimumSpacing_Phone;

            self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancelButton.frame = CGRectMake(0, 0, self.view.width, 44.f);
            [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:24.f];
            self.cancelButton.backgroundColor = UIColor.clearColor;
            [self.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.cancelButton];
        }

        [self setBounds];
    }
    return self;
}

- (NSInteger)numberOfApplications {
    return self.applicationActivities.count;
}

- (void)performActivityInFirstAvailableApplication {
    [self.applicationActivities.firstObject prepareWithActivityItems:self.activityItems];
    [self.applicationActivities.firstObject performActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setBounds];
    self.presentingViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
}

- (void)configureForPad {
    CGRect frame = CGRectMake(0,
                              0,
                              MWActivityViewControllerWidth_Pad,
                              MWActivityViewControllerRowHeight_Pad);
    self.view.frame = frame;
    self.blurToolbar.frame = self.contentView.bounds;
    self.collectionView.frame = self.view.bounds;
}

- (void)configureForPhone {
    int numberOfRows = ceil((CGFloat)self.applicationActivities.count / MWActivityViewControllerItemsPerRow_Phone);

    CGFloat viewHeight = self.cancelButton.height + self.collectionViewLayout.sectionInset.bottom + numberOfRows * MWActivityViewControllerRowHeight_Phone;

    CGRect frame = CGRectMake(0,
                              self.view.bottom - viewHeight,
                              self.view.width,
                              viewHeight);

    CGRect collectionFrame = self.contentView.bounds;
    collectionFrame.size.height -= self.cancelButton.height;
    self.collectionView.frame = collectionFrame;

    self.contentView.frame = frame;
    self.blurToolbar.frame = self.contentView.bounds;

    [self.cancelButton moveToPoint:CGPointMake(0, self.contentView.height - self.cancelButton.height)];

}
- (void)setBounds {
    if (MWOpenInKit.isPad) {
        [self configureForPad];
    } else {
        [self configureForPhone];
    }
}

- (void)didTapCancelButton {
    [self.presenter dismissActivitySheet];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.applicationActivities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MWActivityCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.activity = self.applicationActivities[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIActivity *activity = self.applicationActivities[indexPath.row];
    [activity prepareWithActivityItems:self.activityItems];
    [activity performActivity];

    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
@end
