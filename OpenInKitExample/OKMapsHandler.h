#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OKMapsHandler : NSObject

- (void)searchFor:(NSString *)query near:(CLLocationCoordinate2D)center;

@end
