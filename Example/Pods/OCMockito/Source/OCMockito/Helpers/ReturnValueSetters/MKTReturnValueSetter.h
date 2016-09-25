//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>


/*!
 * @abstract Chain-of-responsibility for converting objects to NSInvocation return values.
 */
@interface MKTReturnValueSetter : NSObject

/*!
 * @abstract Initializes a newly allocated return value setter.
 * @param handlerType Return type managed by this setter. Assign with \@encode compiler directive.
 * @param successor Successor in chain to handle return type.
 */
- (instancetype)initWithType:(char const *)handlerType successor:(MKTReturnValueSetter *)successor;

/*!
 * @abstract Set NSInvocation return value of specified type, or pass to successor.
 */
- (void)setReturnValue:(id)returnValue ofType:(char const *)type onInvocation:(NSInvocation *)invocation;

@end
