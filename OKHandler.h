NSString *(^urlEncode)(NSString *);

@interface OKHandler : NSObject

@property (strong, nonatomic) UIApplication *application;

+ (NSString *)directoryName;

- (void)performCommand:(NSString *)command withArguments:(NSDictionary *)args;

@end
