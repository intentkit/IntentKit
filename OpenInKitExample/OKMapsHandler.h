#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OKHandler.h"

/** Specifies the mode of transporation for turn-by-turn directions. */
typedef NS_ENUM(NSInteger, OKMapsHandlerDirectionsMode) {
    /** Driving/automobile directions */
    OKMapsHandlerDirectionsModeDriving,

    /** Public transit directions */
    OKMapsHandlerDirectionsModeTransit,

    /** Walking directions */
    OKMapsHandlerDirectionsModeWalking
};

/** An instance of `OKMapsHandler` opens third-party mapping applications to perform mapping tasks */
@interface OKMapsHandler : OKHandler

/** Coordinates representing where the map should be centered. This will also be used as a nearly starting location for any text searches. */
@property (nonatomic, assign) CLLocationCoordinate2D center;

/** The amount to zoom in the map. 0 is the most zoomed out, 22 is the most zoomed in. */
@property (nonatomic, assign) NSUInteger zoom;

/** Searches for points of interest on a map
 
 Like all methods in `OKMapsHandler`, this will respect the `center` and `zoom` instance variables.

 @param query What to search for. May be lat/long coordinates, an address, or a business name/point of interest.
 
 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)searchFor:(NSString *)query;


/** Brings up turn-by-turn directions between two locations

 @param from The starting location. May be lat/long coordinates, an address, or a business name/point of interest.
 @param to The destination. May be lat/long coordinates, an address, or a business name/point of interest.
 @param mode An OKMapsHandlerDirectionsMode indicating what mode of transporation to use.

 @warning This does not currently verify that an application can support multiple modes of transportation. If you pick an application that doesn't support the mode of transporation you've asked for, that application will likely ignore that part of the request.

 @return A `UIActivityViewController` to present modally if the user must pick a third-party app. Otherwise nil. */
- (UIActivityViewController *)directionsFrom:(NSString *)from to:(NSString *)to mode:(OKMapsHandlerDirectionsMode)mode;

/** Brings up turn-by-turn driving directions between two locations 
 
 The same as calling `directionsFrom:from to:to mode:OKMapsHandlerDirectionsModeDriving`.

 @see directionsFrom:to:mode: */
- (UIActivityViewController *)directionsFrom:(NSString *)from to:(NSString *)to;

@end
