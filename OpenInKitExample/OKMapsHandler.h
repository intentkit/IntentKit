#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OKHandler.h"

@interface OKMapsHandler : OKHandler

@property (nonatomic, assign) CLLocationCoordinate2D center;
@property (nonatomic, assign) NSUInteger zoom;

- (void)searchFor:(NSString *)query;

@end
