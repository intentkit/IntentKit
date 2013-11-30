#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OKHandler.h"

@interface OKMapsHandler : OKHandler

- (void)searchFor:(NSString *)query near:(CLLocationCoordinate2D)center;

@end
