//  OCHamcrest by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2016 hamcrest.org. See LICENSE.txt

#import "HCArgumentCaptor.h"


@interface HCArgumentCaptor ()
@property (nonatomic, strong, readonly) NSMutableArray *values;
@end

@implementation HCArgumentCaptor

@dynamic allValues;
@dynamic value;

- (instancetype)init
{
    self = [super initWithDescription:@"<Capturing argument>"];
    if (self)
        _values = [[NSMutableArray alloc] init];
    return self;
}

- (BOOL)matches:(id)item
{
    [self capture:item];
    return [super matches:item];
}

- (void)capture:(id)item
{
    id value = item ?: [NSNull null];
    [self.values addObject:value];
}

- (id)value
{
    if (!self.values.count)
        return nil;
    return self.values.lastObject;
}

- (NSArray *)allValues
{
    return [self.values copy];
}

@end
