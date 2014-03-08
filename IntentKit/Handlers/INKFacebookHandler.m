//
// Created by Arvid on 15/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKFacebookHandler.h"
#import "INKActivityPresenter.h"


@implementation INKFacebookHandler

+ (NSString *)name {
    return @"Facebook Client";
}

+ (INKHandlerCategory)category {
    return INKHandlerCategorySocialNetwork;
}

- (INKActivityPresenter *)showProfileWithId:(NSString *)userId {
    NSDictionary *args = @{ @"userId" : userId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];
}

- (INKActivityPresenter *)showEventWithId:(NSString *)eventId {
    NSDictionary *args = @{ @"eventId" : eventId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];
}

@end