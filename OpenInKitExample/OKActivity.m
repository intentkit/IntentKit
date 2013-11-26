#import "OKActivity.h"

@interface OKActivity ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *scheme;
@property (strong, nonatomic) NSDictionary *dict;

@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) NSURL *originalURL;
@property (readonly) UIImage *_activityImage;

@end

@implementation OKActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                       application:(UIApplication *)application {
    if (self = [super init]) {
        self.scheme = dict[@"scheme"];
        self.name = dict[@"name"];
        self.dict = dict;
        self.application = application;
    }
    return self;
}

- (BOOL)isAvailable {
    NSString *urlString = [self.scheme stringByAppendingString:@"://"];
    return [self.application canOpenURL:[NSURL URLWithString:urlString]];
}

#pragma mark - UIActivity methods
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (NSString *)activityTitle {
    return self.name;
}

- (NSString *)activityType {
    return self.name;
}

- (UIImage *)_activityImage {
    return [UIImage imageNamed:self.name];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {

    return (activityItems.count == 1 &&
            [activityItems[0] isKindOfClass:[NSURL class]]);
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.originalURL = [activityItems firstObject];
}

- (void)performActivity {
    NSString *urlString = [NSString stringWithFormat:@"%@:%@",
                        self.scheme,
                        [NSString stringWithFormat:self.dict[@"OpenURL:"], self.originalURL.resourceSpecifier]];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.application openURL:url];
}

@end
