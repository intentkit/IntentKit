#import "OKActivity.h"
#import "NSString+FormatWithArray.h"

@interface OKActivity ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *dict;

@property (readonly) UIImage *_activityImage;

@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) NSString *activityCommand;
@property (strong, nonatomic) NSArray *activityArguments;

@end

@implementation OKActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                       application:(UIApplication *)application {
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.dict = dict;
        self.application = application;
    }
    return self;
}

- (BOOL)isAvailableForCommand:(SEL)cmd arguments:(NSArray *)args {
    NSString *command= NSStringFromSelector(cmd);
    if (!self.dict[command]) { return NO; }

    NSString *urlString = [NSString stringWithFormat:self.dict[command]
                                               array:args];
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
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityCommand = [activityItems firstObject];
    self.activityArguments = [activityItems subarrayWithRange:NSMakeRange(1, activityItems.count - 1)];
}

- (void)performActivity {
    if (!self.dict[self.activityCommand]) { return; }

    NSString *urlString = [NSString stringWithFormat:self.dict[self.activityCommand]
                                                array:self.activityArguments];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.application openURL:url];
}

@end
