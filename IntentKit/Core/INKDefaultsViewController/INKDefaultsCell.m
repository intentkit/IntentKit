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

@implementation INKDefaultsCell

- (void)setHandlerClass:(Class)handlerClass {
    if (handlerClass == _handlerClass || ![handlerClass isSubclassOfClass:[INKHandler class]]) return;

    _handlerClass = handlerClass;

    INKHandler *handler = [[handlerClass alloc] init];
    INKApplicationList *appList = [[INKApplicationList alloc] initWithApplication:[UIApplication sharedApplication] forHandler:handlerClass];

    INKActivity *activity = [appList activityWithName:handler.defaultApp];
    self.imageView.image = activity.activityImage;
    self.textLabel.text = activity.localizedName;
}

@end
