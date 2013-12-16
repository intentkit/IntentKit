//
// Created by Arvid on 17/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWHandler.h"

@class MWActivityPresenter;

@interface MWGPlusHandler : MWHandler

/** Whether it should use a browser fallback or not */
@property (nonatomic) BOOL fallback;

/**
* Shows a specific profile / page
* @param userId The id of the profile / page
* @return A `MWActivityPresenter` object to present
*/
- (MWActivityPresenter *)showGPlusProfileWithId:(NSString *)userId;

/**
* Shows a specific profile / page
* @param userName The name of the profile / page. Without the +!
* @return A `MWActivityPresenter` object to present
*/
- (MWActivityPresenter *)showGPlusProfileWithName:(NSString *)userName;

/**
* Shows a specific event
* @param eventId The id of the event
* @return A `MWActivityPresenter` object to present
*/
- (MWActivityPresenter *)showGPlusEventWithId:(NSString *)eventId;

/**
* Shows a specific community
* @param communityId The id of the community
* @return A `MWActivityPresenter` object to present
*/
- (MWActivityPresenter *)showGPlusCommunityWithId:(NSString *)communityId;

@end