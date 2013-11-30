NSString *(^urlEncode)(NSString *);

@interface OKHandler : NSObject

+ (NSString *)directoryName;

- (void)performCommand:(NSString *)command withArguments:(NSDictionary *)args;

@end
