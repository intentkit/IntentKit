@interface NSString (FormatWithArray)

/** An alias to [NSString stringWithFormat:] that uses an array of arguments rather than a varargs list.
 
 @param format A C-style format string.
 @param arguments An array of arguments corresponding to the placeholders in `format`.
 
 @return An instantiated NSString with a value created from evaluating `[NSString stringWithFormat:]` with the given format and arguments.
 
 */
+ (instancetype)stringWithFormat:(NSString *)format array:(NSArray*)arguments;

@end
