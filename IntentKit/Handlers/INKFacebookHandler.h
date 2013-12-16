//
// Created by Arvid on 15/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKHandler.h"

@class INKActivityPresenter;

/** An instance of `INKFacebookHandler` performs Facebook-related tasks in third-party Facebook apps with browser fallback. */
@interface INKFacebookHandler : INKHandler

/** Whether it should use a browser fallback or not */
@property (nonatomic) BOOL fallback;

/**
* Shows a specific profile / page
* @param userId The id of the profile / page
* @return A `INKActivityPresenter` object to present
*/
- (INKActivityPresenter *)showProfileWithId:(NSString *)userId;

/**
* Shows a specific event
* @param eventId The id of the event
* @return A `INKActivityPresenter` object to present
*/
- (INKActivityPresenter *)showEventWithId:(NSString *)eventId;

@end