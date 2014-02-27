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

@implementation INKDefaultsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
}

- (void)setHandlerClass:(Class)handlerClass {
    if (![handlerClass isSubclassOfClass:[INKHandler class]]) return;

    _handlerClass = handlerClass;

    INKHandler *handler = [[handlerClass alloc] init];
    INKApplicationList *appList = [[INKApplicationList alloc] initWithApplication:[UIApplication sharedApplication] forHandler:handlerClass];

    INKActivity *activity = [appList activityWithName:handler.defaultApp];

    INKAppIconView *iconView = [[INKAppIconView alloc] initWithImage:activity.activityImage];
    [iconView layoutSubviews];

    [iconView maskImageWithCompletion:^(UIImage *maskedImage) {
        self.imageView.image = maskedImage;
        [self setNeedsLayout];
    }];

    self.textLabel.text = activity.localizedName;
    self.detailTextLabel.text = handler.name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView resizeTo:CGSizeMake(32, 32)];
    [self.imageView moveToPoint:CGPointMake(10, 6)];
    [self.textLabel moveToPoint:CGPointMake(55, self.textLabel.top)];

}

@end
