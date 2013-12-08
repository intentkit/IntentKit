//
//  NSString+Helpers
//  MWOpenInKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//
#import "NSString+Helpers.h"

@implementation NSString (Helpers)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*)arguments; {
    NSRange range = NSMakeRange(0, [arguments count]);
    NSMutableData* data = [NSMutableData dataWithLength:sizeof(id) * [arguments count]];
    [arguments getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
    NSString* result = [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    return result;
}

- (NSString *)urlScheme {
    NSString *first = self.pathComponents.firstObject;
    if ([first characterAtIndex:first.length-1] == ':') {
        return [first stringByAppendingString:@"//"];
    }
    return nil;
}

@end
