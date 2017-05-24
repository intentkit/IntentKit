//
//  INKMapsHandler.h
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "INKHandler.h"

@class INKActivityPresenter;

/** Specifies the mode of transporation for turn-by-turn directions. */
typedef NS_ENUM(NSInteger, INKMapsHandlerDirectionsMode) {
    /** Driving/automobile directions */
    INKMapsHandlerDirectionsModeDriving,

    /** Public transit directions */
    INKMapsHandlerDirectionsModeTransit,

    /** Walking directions */
    INKMapsHandlerDirectionsModeWalking
};

/** An instance of `INKMapsHandler` opens third-party mapping applications to perform mapping tasks */
@interface INKMapsHandler : INKHandler

/** Coordinates representing where the map should be centered. This will also be used as a nearly starting location for any text searches. */
@property (nonatomic, assign) CLLocationCoordinate2D center;

/** The amount to zoom in the map. 0 is the most zoomed out, 22 is the most zoomed in. */
@property (nonatomic, assign) NSUInteger zoom;

/** Searches for points of interest on a map
 
 Like all methods in `INKMapsHandler`, this will respect the `center` and `zoom` instance variables.

 @param query What to search for. May be lat/long coordinates, an address, or a business name/point of interest.
 @return A `INKActivityPresenter` object to present. */
- (INKActivityPresenter *)searchForLocation:(NSString *)query;


/** Brings up turn-by-turn directions between two locations

 @param from The starting location. May be lat/long coordinates, an address, or a business name/point of interest.
 @param to The destination. May be lat/long coordinates, an address, or a business name/point of interest.
 @param mode An INKMapsHandlerDirectionsMode indicating what mode of transporation to use.
 @return A `INKActivityPresenter` object to present.

 @warning This does not currently verify that an application can support multiple modes of transportation. If you pick an application that doesn't support the mode of transporation you've asked for, that application will likely ignore that part of the request. */
- (INKActivityPresenter *)directionsFrom:(NSString *)from to:(NSString *)to mode:(INKMapsHandlerDirectionsMode)mode;

/** Brings up turn-by-turn driving directions between two locations 
 
 The same as calling `directionsFrom:to:mode:` with `INKMapsHandlerDirectionsModeDriving` for the `mode` value.

 @see directionsFrom:to:mode: */
- (INKActivityPresenter *)directionsFrom:(NSString *)from to:(NSString *)to;


/** Opens a specific point in a map

 @param coordinate Coordinate to open
 @param title String Name of the location. Note that some providers can not display name
 @return A `INKActivityPresenter` object to present. */
- (INKActivityPresenter *)openLocation:(CLLocationCoordinate2D)coordinate title:(NSString *)title;


@end
