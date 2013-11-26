#import <UIKit/UIKit.h>

@interface OKActivity : UIActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                       application:(UIApplication *)application;

- (BOOL)isAvailableForCommand:(SEL)cmd arguments:(NSArray *)args;

@end
