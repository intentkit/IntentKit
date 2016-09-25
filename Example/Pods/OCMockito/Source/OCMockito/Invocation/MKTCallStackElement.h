//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>


@interface MKTCallStackElement : NSObject

@property (nonatomic, copy, readonly) NSString *moduleName;
@property (nonatomic, copy, readonly) NSString *instruction;

- (instancetype)initWithSymbols:(NSString *)element;

@end
