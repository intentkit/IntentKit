

# MWLayoutHelpers

This is a small category on UIView that adds a few methods to aid in manual frame layout.

There are already a million libraries like this out there; I can't make a strong argument why mine's inherently better than any other.

## Installation
Using Cocoapods:

    pod "MWLayoutHelpers"

If you're not using CocoaPods, just drag the "Classes" folder into your project.


## Usage
In general, there are two types of methods in here:

**Shorthand accessors**: Lets you avoid deeply introspecting into child properties. For example, to get the width of a view, instead of using `someview.frame.size.width` or `CGRectGetWidth(someView)` you can just use `someView.width`.

**Shorthand setters**: Lets you avoid creating throwaway instance variables to muck around with setting inner properties of a view's frame. If you just want to move a view while keeping its size, instead of doing this:

    CGRect frame = someView.frame;
    frame.origin = CGPointMake(0, 0);
    someView.frame = frame;

You can just call:

    someView.x = 0;
    someView.y = 0;

Alternatively, you could also call `[someView moveToPoint:CGPointZero]`;

For full usage, check out the `UIView+MWLayoutHelpers.h` header file.


## Contact
Mike Walker

* https://github.com/lazerwalker
* [@lazerwalker](https://twitter.com/lazerwalker)
* mike@lazerwalker.com

## License
[MIT License](https://github.com/lazerwalker/MWLayoutHelpers/blob/master/LICENSE).
