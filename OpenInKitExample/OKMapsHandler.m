#import "OKMapsHandler.h"
#import "OKActivity.h"

@implementation OKMapsHandler

+ (NSString *)directoryName {
    return @"Maps";
}

+ (NSDictionary *)directionModes {
  return @{
    @(OKMapsHandlerDirectionsModeDriving): @"driving",
    @(OKMapsHandlerDirectionsModeTransit): @"transit",
    @(OKMapsHandlerDirectionsModeWalking): @"walking"};
}

- (instancetype)init {
    if (self = [super init]) {
        self.zoom = -1;
        self.center = CLLocationCoordinate2DMake(91, 181);
    }
    return self;
}

- (void)searchFor:(NSString *)query {
    NSString *command = NSStringFromSelector(_cmd);
    NSDictionary *args = [self argsDictionaryWithDictionary: @{@"query": urlEncode(query)}];

    [self performCommand:command withArguments:args];
}

- (void)directionsFrom:(NSString *)from to:(NSString *)to mode:(OKMapsHandlerDirectionsMode)mode {
    NSString *command = NSStringFromSelector(_cmd);
    NSString *modeString = self.class.directionModes[@(mode)];
    NSDictionary *args = [self argsDictionaryWithDictionary:
                          @{@"from": urlEncode(from),
                           @"to": urlEncode(to),
                           @"mode": modeString}];

    [self performCommand:command withArguments:args];
}

- (void)directionsFrom:(NSString *)from to:(NSString *)to {
    [self directionsFrom:from to:to mode:OKMapsHandlerDirectionsModeDriving];
}

#pragma mark - Private methods
- (NSDictionary *)argsDictionaryWithDictionary:(NSDictionary *)args {
    NSMutableDictionary *newArgs = [args mutableCopy];
    if (CLLocationCoordinate2DIsValid(self.center)) {
        newArgs[@"center"] = [NSString stringWithFormat:@"%f,%f", self.center.latitude, self.center.longitude];
    }

    if (self.zoom != -1) {
        newArgs[@"zoom"] = [NSString stringWithFormat:@"%lu", (unsigned long)self.zoom];
    }

    return [newArgs copy];
}
@end
