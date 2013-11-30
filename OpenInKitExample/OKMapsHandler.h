#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OKHandler.h"

typedef NS_ENUM(NSInteger, OKMapsHandlerDirectionsMode) {
    OKMapsHandlerDirectionsModeDriving,
    OKMapsHandlerDirectionsModeTransit,
    OKMapsHandlerDirectionsModeWalking
};

@interface OKMapsHandler : OKHandler

@property (nonatomic, assign) CLLocationCoordinate2D center;
@property (nonatomic, assign) NSUInteger zoom;

- (void)searchFor:(NSString *)query;
- (void)directionsFrom:(NSString *)from to:(NSString *)to mode:(OKMapsHandlerDirectionsMode)mode;
- (void)directionsFrom:(NSString *)from to:(NSString *)to;

@end
