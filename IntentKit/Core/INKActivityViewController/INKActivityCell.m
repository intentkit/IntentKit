//
//  INKActivityCell.m
//  INKOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKActivityCell.h"
#import "IntentKit.h"
#import "INKAppIconView.h"

#import <MWLayoutHelpers/UIView+MWLayoutHelpers.h>

@interface INKActivityCell ()
@property (strong, nonatomic) INKAppIconView *iconView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation INKActivityCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconView = [[INKAppIconView alloc] init];
        [self addSubview:self.iconView];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11.f];
        [self addSubview:self.titleLabel];

    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSNumber *iconSize = @(self.iconView.width);

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
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.text = self.activity.activityTitle;
    [self.titleLabel sizeToFit];
    [self.titleLabel resizeTo:CGSizeMake(self.width, self.titleLabel.height)];

    [self setNeedsUpdateConstraints];
}

- (void)setActivity:(UIActivity *)activity {
    _activity = activity;
    self.iconView.image = activity.activityImage;
    [self setNeedsLayout];
}

@end
