#import "OKMapsHandler.h"
#import "OKActivity.h"

@implementation OKMapsHandler

+ (NSString *)directoryName {
    return @"Maps";
}

- (void)searchFor:(NSString *)query near:(CLLocationCoordinate2D)center {
    NSString *command = NSStringFromSelector(_cmd);
    NSString *centerString = [NSString stringWithFormat:@"%f,%f", center.latitude, center.longitude];
    NSDictionary *args = @{@"query": urlEncode(query),
                      @"center": centerString};

    [self performCommand:command withArguments:args];
}
@end
