NSString *(^urlEncode)(NSString *);

@interface OKHandler : NSObject

+ (NSString *)directoryName;

- (UIActivityViewController *)performCommand:(NSString *)command withArguments:(NSDictionary *)args;

@end
