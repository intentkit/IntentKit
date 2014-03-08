//
//  INKMapsHandler.m
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKMapsHandler.h"
#import "INKActivity.h"

@implementation INKMapsHandler

+ (NSDictionary *)directionModes {
  return @{
    @(INKMapsHandlerDirectionsModeDriving): @"driving",
    @(INKMapsHandlerDirectionsModeTransit): @"transit",
    @(INKMapsHandlerDirectionsModeWalking): @"walking"};
}

- (NSString *)name {
    return @"Mapping App";
}

+ (INKHandlerCategory)category {
    return INKHandlerCategoryUtility;
}

- (instancetype)init {
    if (self = [super init]) {
        self.zoom = -1;
        self.center = CLLocationCoordinate2DMake(91, 181);
    }
    return self;
}

- (INKActivityPresenter *)searchForLocation:(NSString *)query {
    NSString *command = NSStringFromSelector(_cmd);
    NSDictionary *args = [self argsDictionaryWithDictionary: @{@"query": urlEncode(query)}];

    return [self performCommand:command withArguments:args];
}

- (INKActivityPresenter *)directionsFrom:(NSString *)from to:(NSString *)to mode:(INKMapsHandlerDirectionsMode)mode {
    NSString *command = NSStringFromSelector(_cmd);
    NSString *modeString = self.class.directionModes[@(mode)];
    NSDictionary *args = [self argsDictionaryWithDictionary:
                          @{@"from": urlEncode(from),
                           @"to": urlEncode(to),
                           @"mode": modeString}];

    return [self performCommand:command withArguments:args];
}

- (INKActivityPresenter *)directionsFrom:(NSString *)from to:(NSString *)to {
    return [self directionsFrom:from to:to mode:INKMapsHandlerDirectionsModeDriving];
}

#pragma mark - Private methods
- (NSDictionary *)argsDictionaryWithDictionary:(NSDictionary *)args {
    NSMutableDictionary *newArgs = [args mutableCopy];
    if (CLLocationCoordinate2DIsValid(self.center)) {
        newArgs[@"center"] = [NSString stringWithFormat:@"%f,%f", self.center.latitude, self.center.longitude];
    }

    if (self.zoom != -1) {
        newArgs[@"zoom"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.zoom];
    }

    return [newArgs copy];
}
@end
