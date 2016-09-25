//  OCMockito by Jon Reid, http://qualitycoding.org/about/
//  Copyright 2015 Jonathan M. Reid. See LICENSE.txt

#import "MKTAnswer.h"


/*!
 * @abstract Method answer that returns a value.
 */
@interface MKTReturnsValue : NSObject <MKTAnswer>

- (instancetype)initWithValue:(id)value;

@end
