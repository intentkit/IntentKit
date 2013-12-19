//
// Created by Arvid on 17/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKHandler.h"

@class INKActivityPresenter;

@interface INKGPlusHandler : INKHandler

/** Whether it should use a browser fallback or not */
@property (nonatomic) BOOL fallback;

/**
* Shows a specific profile / page
* @param userId The id of the profile / page
* @return A `INKActivityPresenter` object to present
*/
- (INKActivityPresenter *)showGPlusProfileWithId:(NSString *)userId;

/**
* Shows a specific profile / page
* @param userName The name of the profile / page. Without the +!
* @return A `INKActivityPresenter` object to present
*/
- (INKActivityPresenter *)showGPlusProfileWithName:(NSString *)userName;

/**
* Shows a specific event
* @param eventId The id of the event
* @return A `INKActivityPresenter` object to present
*/
- (INKActivityPresenter *)showGPlusEventWithId:(NSString *)eventId;

/**
* Shows a specific community
* @param communityId The id of the community
* @return A `MWActivityPresenter` object to present
*/
- (INKActivityPresenter *)showGPlusCommunityWithId:(NSString *)communityId;

@end