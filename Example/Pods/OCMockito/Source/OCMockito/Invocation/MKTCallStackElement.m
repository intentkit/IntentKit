//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTCallStackElement.h"


static NSRange trimTrailingSpacesFromRange(NSString *string, NSRange range)
{
    while ([string characterAtIndex:range.location + range.length - 1] == ' ')
        range.length -= 1;
    return range;
}

static NSString *extractModuleName(NSString *element)
{
    NSRange range = trimTrailingSpacesFromRange(element, NSMakeRange(4, 33));
    return [element substringWithRange:range];
}

static BOOL isAddress32Bit(NSString *element)
{
    return [element characterAtIndex:50] == ' ';
}

static NSString *extractInstruction(NSString *element)
{
    NSUInteger loc = 59;
    if (isAddress32Bit(element))
        loc -= 8;
    NSRange range = NSMakeRange(loc, element.length - loc);
    return [element substringWithRange:range];
}


@implementation MKTCallStackElement

- (instancetype)initWithSymbols:(NSString *)element
{
    self = [super init];
    if (self)
    {
        _moduleName = extractModuleName(element);
        _instruction = extractInstruction(element);
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.moduleName, self.instruction];
}

@end
