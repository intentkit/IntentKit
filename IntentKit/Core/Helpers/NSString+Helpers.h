//
//  NSString+FormatWithArray.h
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

NSString *(^ink_urlEncode)(NSString *);

@interface NSString (Helpers)

/** If the string is URL-like, will return a string containing the URL scheme and trailing :// */
@property (readonly) NSString *urlScheme;

/** Evaluates a {handlebar-style} template string for some given template data.
 
 For example, calling this on the string `@"Hi, {name}!"` with the dictionary `@{@"name":@"Mom"}` will return `@"Hi, Mom!"`.

 @param data A dictionary mapping template variable names to replacement values
 @return A copy of the current string, with all instances of variable names wrapped in curly braces replaced with the appropriate data from the dictionary.*/
- (NSString *)stringByEvaluatingTemplateWithData:(NSDictionary *)data;

/** Creates a query param string from a templated dictionary, and appends it onto the given string.
 @param params A dictionary mapping from a param's user-readable name to the actual templated parameter code to use
 @param data A dictionary mapping template variable names to replacement values
 @return A copy of the current string with a well-formed query params string appended at the end, with all instances of variable names wrapped in curly braces replaced with the appropriate data. */
- (NSString *)stringWithTemplatedQueryParams:(NSDictionary *)params
                                        data:(NSDictionary *)data;

/** An alias to [NSString stringWithFormat:] that uses an array of arguments rather than a varargs list.
 
 @param format A C-style format string.
 @param arguments An array of arguments corresponding to the placeholders in `format`.
 
 @return An instantiated NSString with a value created from evaluating `[NSString stringWithFormat:]` with the given format and arguments.
 
 */
+ (instancetype)stringWithFormat:(NSString *)format array:(NSArray*)arguments;

@end
