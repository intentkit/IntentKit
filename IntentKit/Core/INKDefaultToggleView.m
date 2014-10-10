//
//  INKDefaultToggleView.m
//  IntentKitDemo
//
//  Created by Michael Walker on 12/18/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKDefaultToggleView.h"
#import "INKLocalizedString.h"
#import <MWLayoutHelpers/UIView+MWLayoutHelpers.h>

@interface INKDefaultToggleView ()

@property (strong, nonatomic) UISwitch *toggle;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UIView *disabledShade;
@end

@implementation INKDefaultToggleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.toggle = [[UISwitch alloc] init];
        [self addSubview:self.toggle];

        self.label = [[UILabel alloc] init];

        self.label.text = INKLocalizedString(@"SetDefaultToggleLabel", nil);
        self.label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTextLabel)];
        [self.label addGestureRecognizer:tapRecognizer];
        self.label.userInteractionEnabled = YES;
        [self addSubview:self.label];

        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        [self addSubview:self.bottomLine];

        [self resizeTo:CGSizeMake(0, 50.f)];
    }
    return self;
}

- (BOOL)isOn {
    return self.toggle.isOn;
}

- (void)setIsOn:(BOOL)isOn {
    [self.toggle setOn:isOn animated:YES];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.alpha = (enabled ? 1.0 : 0.4);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bottomLine.frame = CGRectMake(0, self.bottom-1, self.width, 1);
    self.disabledShade.frame = self.bounds;
}

- (void)updateConstraints {
    [super updateConstraints];

    NSArray *layoutStrings = @[@"|-15-[toggle]-10-[label]-15-|",
                               @"V:|-10-[toggle]-10-|",
                               @"V:|-10-[label]-10-|"
                               ];

    NSDictionary *views = @{@"toggle": self.toggle,
                            @"label": self.label};
    for (NSString *layoutString in layoutStrings) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
    }

    for (NSString *key in views) {
        [views[key] setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - Event handlers
- (void)didTapTextLabel {
    [self.toggle setOn:!self.toggle.isOn animated:YES];
}


@end
