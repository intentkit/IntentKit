//
// Created by Arvid on 15/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWFacebookHandler.h"
#import "MWActivityPresenter.h"


@implementation MWFacebookHandler
@synthesize fallback;

- (id)init {
    self = [super init];
    if (self) {
        [self setFallback:NO];
    }

    return self;
}

- (MWActivityPresenter *)showProfileWithId:(NSString *)userId {
    NSDictionary *args = @{ @"userId" : userId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args fallback:[self fallback]];
}

- (MWActivityPresenter *)showEventWithId:(NSString *)eventId {
    NSDictionary *args = @{ @"eventId" : eventId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args fallback:[self fallback]];
}

@end