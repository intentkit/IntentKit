//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import <Foundation/Foundation.h>


/*!
 * @abstract Specifies an action that is executed and a return value that is returned when you
 * interact with the mock.
 */
@protocol MKTAnswer <NSObject>

/*!
 * @abstract Answer a particular invocation.
 * @param invocation Method invocation to answer.
 * @return The value to be returned.
 */
- (id)answerInvocation:(NSInvocation *)invocation;

@end
