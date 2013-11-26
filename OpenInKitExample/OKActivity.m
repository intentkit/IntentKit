#import "OKActivity.h"

@interface OKActivity ()
@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) UIApplication *application;
@property (readonly) UIImage *_activityImage;
@end

@implementation OKActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                       application:(UIApplication *)application {
    if (self = [super init]) {
        self.dict = dict;
        self.application = application;
    }
    return self;
}

#pragma mark - UIActivity methods
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (NSString *)activityTitle {
    return self.dict[@"name"];
}

- (NSString *)activityType {
    return self.dict[@"name"];
}

- (UIImage *)_activityImage {
    return [UIImage imageNamed:self.dict[@"name"]];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)performActivity {

}

@end
