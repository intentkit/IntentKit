//
// Created by Arvid on 17/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWGPlusHandler.h"
#import "MWActivityPresenter.h"


@implementation MWGPlusHandler
@synthesize fallback;

- (id)init {
    self = [super init];
    if (self) {
        [self setFallback:NO];
    }

    return self;
}

- (MWActivityPresenter *)showGPlusProfileWithId:(NSString *)userId {
    NSDictionary *args = @{ @"userId" : userId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args fallback:[self fallback]];
}

- (MWActivityPresenter *)showGPlusProfileWithName:(NSString *)userName {
    NSDictionary *args = @{ @"userName" : userName };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args fallback:[self fallback]];
}

- (MWActivityPresenter *)showGPlusEventWithId:(NSString *)eventId {
    NSDictionary *args = @{ @"eventId" : eventId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args fallback:[self fallback]];
}

- (MWActivityPresenter *)showGPlusCommunityWithId:(NSString *)communityId {
    NSDictionary *args = @{ @"communityId" : communityId };
    return [self performCommand:NSStringFromSelector(_cmd) withArguments:args fallback:[self fallback]];
}


@end