//
//  NSString+Helpers
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//
#import "NSString+Helpers.h"

NSString *(^ink_urlEncode)(NSString *) = ^NSString *(NSString *input){
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    kCFAllocatorDefault,
                                                                    (CFStringRef)input,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'();:@&=+$?%#/[]",
                                                                    kCFStringEncodingUTF8);
    return (__bridge NSString *)urlString;
};

@implementation NSString (Helpers)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*)arguments; {
    NSRange range = NSMakeRange(0, [arguments count]);
    NSMutableData* data = [NSMutableData dataWithLength:sizeof(id) * [arguments count]];
    [arguments getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
    NSString* result = [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    return result;
}

- (NSString *)stringByEvaluatingTemplateWithData:(NSDictionary *)data {
    NSString *tempString = [self copy];
    for (NSString *key in data) {
        NSString *value = data[key];

        NSString *handlebarKey = [NSString stringWithFormat:@"{{{%@}}}", key];
        tempString = [tempString stringByReplacingOccurrencesOfString:handlebarKey withString:value];

        handlebarKey = [NSString stringWithFormat:@"{{%@}}", key];
        tempString = [tempString stringByReplacingOccurrencesOfString:handlebarKey withString:ink_urlEncode(value)];
    }
    return tempString;
}

- (NSString *)stringWithTemplatedQueryParams:(NSDictionary *)params data:(NSDictionary *)data {
    NSMutableArray *evaluatedParams = [NSMutableArray array];

    for (NSString *key in data) {
        NSString *optionalParam = params[key];
        if (optionalParam) {
            NSString *value = data[key];

            NSString *handlebarKey = [NSString stringWithFormat:@"{{{%@}}}", key];
            NSString *optionalString = [optionalParam stringByReplacingOccurrencesOfString:handlebarKey
                                                                                withString:value];

            handlebarKey = [NSString stringWithFormat:@"{{%@}}", key];
            optionalString = [optionalString stringByReplacingOccurrencesOfString:handlebarKey
                                                                                withString:ink_urlEncode(value)];

            [evaluatedParams addObject:optionalString];
        }
    }

    if (evaluatedParams.count > 0 && [self rangeOfString:@"?"].location == NSNotFound) {
        NSString *firstParam = evaluatedParams.firstObject;
        NSRange firstAmpersand = [firstParam rangeOfString:@"&"];

        if (firstAmpersand.location != NSNotFound) {
            evaluatedParams[0] = [firstParam stringByReplacingCharactersInRange:firstAmpersand withString:@"?"];
        }
    }

    return [self stringByAppendingString:[evaluatedParams componentsJoinedByString:@""]];
}

- (NSString *)urlScheme {
    // TODO Think of a better solution for this dirty hack.
    if ([self hasPrefix:@"mailto:"]) {
        return @"mailto:";
    }

    NSString *first = self.pathComponents.firstObject;
    if ([first characterAtIndex:first.length-1] == ':') {
        return [first stringByAppendingString:@"//"];
    }
    return nil;
}

@end
