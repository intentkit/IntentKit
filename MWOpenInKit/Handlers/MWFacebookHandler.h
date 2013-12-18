//
// Created by Arvid on 15/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "MWHandler.h"

@class MWActivityPresenter;

/** An instance of `MWFacebookHandler` performs Facebook-related tasks in third-party Facebook apps with browser fallback. */
@interface MWFacebookHandler : MWHandler

/** Whether it should use a browser fallback or not */
@property (nonatomic) BOOL fallback;

/**
* Shows a specific profile / page
* @param userId The id of the profile / page
* @return A `MWActivityPresenter` object to present
*/
- (MWActivityPresenter *)showProfileWithId:(NSString *)userId;

/**
* Shows a specific event
* @param eventId The id of the event
* @return A `MWActivityPresenter` object to present
*/
- (MWActivityPresenter *)showEventWithId:(NSString *)eventId;

@end