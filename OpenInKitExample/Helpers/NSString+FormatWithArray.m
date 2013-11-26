#import "NSString+FormatWithArray.h"

@implementation NSString (FormatWithArray)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*)arguments; {
    NSRange range = NSMakeRange(0, [arguments count]);
    NSMutableData* data = [NSMutableData dataWithLength:sizeof(id) * [arguments count]];
    [arguments getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
    NSString* result = [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    return result;
}

@end
