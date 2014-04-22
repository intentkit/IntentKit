//
//  INKDefaultsCell.m
//  IntentKitDemo
//
//  Created by Michael Walker on 2/27/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import "INKDefaultsCell.h"
#import "INKHandler.h"
#import "INKActivity.h"
#import "INKApplicationList.h"
#import "INKAppIconView.h"

#import <UIView+MWLayoutHelpers.h>

@interface INKDefaultsCell ()
@property (readwrite, assign, nonatomic) BOOL isUsingFallback;
@end

@implementation INKDefaultsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
}

- (void)setHandlerClass:(Class)handlerClass {
    if (![handlerClass isSubclassOfClass:[INKHandler class]]) return;

    self.isUsingFallback = NO;

    _handlerClass = handlerClass;

    INKHandler *handler = [[handlerClass alloc] init];
    handler.useSystemDefault = YES;
    
    INKApplicationList *appList = [[INKApplicationList alloc] initWithApplication:[UIApplication sharedApplication] forHandler:handlerClass];

    INKActivity *activity = [appList activityWithName:handler.defaultApp];

    if (activity.isAvailableOnDevice) {
        [self renderActivity:activity];
    } else if (appList.availableActivities.count > 0) {
        [self renderActivity:appList.availableActivities.firstObject];
    } else if (appList.canUseFallback) {
        self.isUsingFallback = YES;
        Class browserClass = NSClassFromString(@"INKBrowserHandler");
        INKHandler *browserHandler = [[browserClass alloc] init];
        browserHandler.useSystemDefault = YES;
        appList = [[INKApplicationList alloc] initWithApplication:[UIApplication sharedApplication] forHandler:browserClass];
        activity = [appList activityWithName:browserHandler.defaultApp];

        [self renderActivity:activity];
    } else {
        self.textLabel.text = @"No apps installed";
    }

    self.detailTextLabel.text = [handlerClass name];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView resizeTo:CGSizeMake(32, 32)];
    [self.imageView moveToPoint:CGPointMake(10, 6)];
    [self.textLabel moveToPoint:CGPointMake(55, self.textLabel.top)];
}

- (void)renderActivity:(INKActivity *)activity {
    INKAppIconView *iconView = [[INKAppIconView alloc] initWithImage:activity.activityImage];
    [iconView layoutSubviews];

    [iconView maskImageWithCompletion:^(UIImage *maskedImage) {
        self.imageView.image = maskedImage;
        [self setNeedsLayout];
    }];

    self.textLabel.text = activity.activityTitle;
}

@end
