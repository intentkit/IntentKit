#import <UIKit/UIKit.h>

@interface OKActivity : UIActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                       application:(UIApplication *)application;

- (BOOL)isAvailableForCommand:(NSString *)command arguments:(NSDictionary *)args;

@end
