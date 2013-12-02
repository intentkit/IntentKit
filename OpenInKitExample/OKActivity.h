#import <UIKit/UIKit.h>

@interface OKActivity : UIActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                              name: (NSString *)name
                       application:(UIApplication *)application;

- (BOOL)isAvailableForCommand:(NSString *)command arguments:(NSDictionary *)args;

@end
