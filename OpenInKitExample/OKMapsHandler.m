#import "OKMapsHandler.h"
#import "OKActivity.h"

@implementation OKMapsHandler

+ (NSString *)directoryName {
    return @"Maps";
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
@end
