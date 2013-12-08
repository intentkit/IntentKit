//
//  MWApplicationList.h
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/8/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A `MWApplicationList` is a data source that provides a list of third-party applications. */
@interface MWApplicationList : NSObject

/** An array containing MWActivity objects representing every possible third-party app, 
 including ones that aren't installed or aren't relevant to a given handler. */
@property (readonly) NSArray *activities;

/** Custom constructor to stub out UIApplication in test. */
- (instancetype)initWithApplication:(UIApplication *)application;

@end
