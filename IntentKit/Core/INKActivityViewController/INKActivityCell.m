//
//  INKActivityCell.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKActivityCell.h"
#import "IntentKit.h"
#import <MWLayoutHelpers/UIView+MWLayoutHelpers.h>

CGFloat const INKActivityCellIconSize_Pad = 76.f;
CGFloat const INKActivityCellIconSize_Phone = 60.f;

static NSString *INKActivityCellIconMask = @"iconMask";
static NSString *INKActivityCellIconBorder = @"iconBorder";

@interface INKActivityCell ()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UIImageView *iconBorder;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation INKActivityCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconView = [[UIImageView alloc] init];
        [self addSubview:self.iconView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11.f];
        [self addSubview:self.titleLabel];

        self.iconBorder = [[UIImageView alloc] init];
        self.iconBorder.image = [[self imageNamed:INKActivityCellIconBorder]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.iconBorder.tintColor = [UIColor blackColor];
        [self addSubview:self.iconBorder];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSNumber *iconSize = @(IntentKit.sharedInstance.isPad ?
    INKActivityCellIconSize_Pad : INKActivityCellIconSize_Phone);

    NSDictionary *metrics = NSDictionaryOfVariableBindings(iconSize);
    NSDictionary *views = @{@"icon": self.iconView,
                            @"title": self.titleLabel};

    NSArray *layoutStrings = @[@"|-(>=0)-[icon(iconSize)]-(>=0)-|",
                               @"|-0-[title]-0-|",
                               @"V:|-0-[icon(iconSize)]-5-[title]-|"
                               ];

    for (NSString *layoutString in layoutStrings) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
    }

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.iconView.superview
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.f constant:0.f]];

    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconBorder.frame = self.iconView.frame;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.text = self.activity.activityTitle;
    [self.titleLabel sizeToFit];
    [self.titleLabel resizeTo:CGSizeMake(self.width, self.titleLabel.height)];

    __weak UIImageView *iconView = self.iconView;
    [self maskImage:self.activity.activityImage completion:^(UIImage *maskedImage) {
        iconView.image = maskedImage;
    }];

    [self setNeedsUpdateConstraints];
}

- (void)setActivity:(UIActivity *)activity {
    _activity = activity;
    [self setNeedsLayout];
}

#pragma mark - Private methods

- (UIImage *)imageNamed:(NSString *)name {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"IntentKit" withExtension:@"bundle"];
    NSBundle *bundle;
    if (bundleURL) {
        bundle  = [NSBundle bundleWithURL:bundleURL];
    }
    NSString *filename = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:filename];
}

- (void)maskImage:(UIImage *)image completion:(void(^)(UIImage *maskedImage))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        CGImageRef maskRef = [[self imageNamed:INKActivityCellIconMask]CGImage];

        CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                            CGImageGetHeight(maskRef),
                                            CGImageGetBitsPerComponent(maskRef),
                                            CGImageGetBitsPerPixel(maskRef),
                                            CGImageGetBytesPerRow(maskRef),
                                            CGImageGetDataProvider(maskRef), NULL, false);
        CGImageRef maskedImageRef = CGImageCreateWithMask(image.CGImage, mask);
        CGFloat scale = UIScreen.mainScreen.scale;
        UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(mask);
        CGImageRelease(maskedImageRef);

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(maskedImage);
            }
        });
    });
}

@end
