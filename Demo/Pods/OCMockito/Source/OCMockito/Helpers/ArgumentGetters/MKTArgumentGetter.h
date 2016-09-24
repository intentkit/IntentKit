//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>


/*!
 * @abstract Chain-of-responsibility for converting NSInvocation argument to object.
 */
@interface MKTArgumentGetter : NSObject

/*!
 * @abstract Initializes a newly allocated argument getter.
 * @param handlerType Argument type managed by this getter. Assign with \@encode compiler directive.
 * @param successor Successor in chain to handle argument type.
 */
- (instancetype)initWithType:(char const *)handlerType successor:(MKTArgumentGetter *)successor;

/*!
 * @abstract Retrieve designated argument of specified type from NSInvocation, or pass to successor.
 */
- (id)retrieveArgumentAtIndex:(NSInteger)idx ofType:(char const *)type onInvocation:(NSInvocation *)invocation;

@end
