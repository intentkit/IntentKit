![mockito](http://docs.mockito.googlecode.com/hg/latest/org/mockito/logo.jpg)

[![Build Status](https://travis-ci.org/jonreid/OCMockito.svg?branch=master)](https://travis-ci.org/jonreid/OCMockito) [![Coverage Status](https://coveralls.io/repos/jonreid/OCMockito/badge.svg?branch=master)](https://coveralls.io/r/jonreid/OCMockito?branch=master) [![Cocoapods Version](https://cocoapod-badges.herokuapp.com/v/OCMockito/badge.png)](http://cocoapods.org/pods/OCMockito)

OCMockito is an iOS and Mac OS X implementation of Mockito, supporting creation,
verification and stubbing of mock objects.

Key differences from other mocking frameworks:

* Mock objects are always "nice," recording their calls instead of throwing
  exceptions about unspecified invocations. This makes tests less fragile.

* No expect-run-verify, making tests more readable. Mock objects record their
  calls, then you verify the methods you want.

* Verification failures are reported as unit test failures, identifying specific
  lines instead of throwing exceptions. This makes it easier to identify
  failures.


How do I add OCMockito to my project?
-------------------------------------

The Examples folder shows projects using OCMockito either through CocoaPods or
through the prebuilt frameworks, for iOS and Mac OS X development.

### CocoaPods

If you want to add OCMockito using Cocoapods then add the following dependency
to your Podfile. Most people will want OCMockito in their test targets, and not
include any pods from their main targets:

```ruby
target :MyTests, :exclusive => true do
  pod 'OCMockito', '~> 3.0'
end
```

Use the following imports:

    #import <OCHamcrest/OCHamcrest.h>
    #import <OCMockito/OCMockito.h>

### Prebuilt Frameworks

Prebuilt binaries are available on GitHub for
[OCMockito](https://github.com/jonreid/OCMockito/releases/). You will also need
[OCHamcrest](https://github.com/hamcrest/OCHamcrest/releases/).
The binaries are packaged as frameworks:

* __OCMockitoIOS.framework__ for iOS development
* __OCMockito.framework__ for Mac OS X development

OCHamcrest comes in a similar scheme. Drag the appropriate frameworks for both
both OCMockito and OCHamcrest into your project, specifying "Copy items into
destination group's folder". Then specify `-ObjC` in your "Other Linker Flags".

#### iOS Development:

Use the following imports:

    #import <OCHamcrestIOS/OCHamcrestIOS.h>
    #import <OCMockitoIOS/OCMockitoIOS.h>


#### Mac OS X Development:

Add a "Copy Files" build phase to copy OCMockito.framework and
OCHamcrest.framework to your Products Directory.

Use the following imports:

    #import <OCHamcrest/OCHamcrest.h>
    #import <OCMockito/OCMockito.h>


### Build Your Own

If you want to build OCMockito yourself, clone the repo, then

```sh
$ Frameworks/gethamcrest
$ cd Source
$ ./MakeDistribution.sh
```
 

Let's verify some behavior!
---------------------------

```obj-c
// mock creation
NSMutableArray *mockArray = mock([NSMutableArray class]);

// using mock object
[mockArray addObject:@"one"];
[mockArray removeAllObjects];

// verification
[verify(mockArray) addObject:@"one"];
[verify(mockArray) removeAllObjects];
```

Once created, the mock will remember all interactions. Then you can selectively
verify whatever interactions you are interested in.

(If Xcode complains about multiple methods with the same name, cast `verify`
to the mocked class.)


How about some stubbing?
------------------------

```obj-c
// mock creation
NSArray *mockArray = mock([NSArray class]);

// stubbing
[given([mockArray objectAtIndex:0]) willReturn:@"first"];
[given([mockArray objectAtIndex:1]) willThrow:[NSException exceptionWithName:@"name"
                                                                      reason:@"reason"
                                                                    userInfo:nil]];

// following prints "first"
NSLog(@"%@", [mockArray objectAtIndex:0]);

// follows throws exception
NSLog(@"%@", [mockArray objectAtIndex:1]);

// following prints "(null)" because objectAtIndex:999 was not stubbed
NSLog(@"%@", [mockArray objectAtIndex:999]);
```


How do you mock a class object?
-------------------------------

```obj-c
__strong Class mockStringClass = mockClass([NSString class]);
```

(In the iOS 64-bit runtime, Class objects aren't strong by default. Either make
it explicitly strong as shown above, or use `id` instead.)


How do you mock a protocol?
---------------------------

```obj-c
id <MyDelegate> delegate = mockProtocol(@protocol(MyDelegate));
```

Or, if you don't want it to contain any optional methods:

```obj-c
id <MyDelegate> delegate = mockProtocolWithoutOptionals(@protocol(MyDelegate));
```


How do you mock an object that also implements a protocol?
----------------------------------------------------------

```obj-c
UIViewController <CustomProtocol> *controller =
    mockObjectAndProtocol([UIViewController class], @protocol(CustomProtocol));
```


How do you stub methods that return primitives?
-----------------------------------------------

To stub methods that return primitive scalars, box the scalars into NSValues:

```obj-c
[given([mockArray count]) willReturn:@3];
```


How do you stub methods that return structs?
--------------------------------------------

Use `willReturnStruct:objCType:` passing a pointer to your structure and its
type from the Objective-C `@encode()` compiler directive:

```obj-c
SomeStruct aStruct = {...};
[given([mockObject methodReturningStruct]) willReturnStruct:&aStruct
                                                   objCType:@encode(SomeStruct)];
```


How do you stub a property so that KVO works?
---------------------------------------------

Use `stubProperty(instance, property, value)`. For example:

```obj-c
stubProperty(mockEmployee, firstName, @"fake-firstname");
```


Argument matchers
-----------------

OCMockito verifies argument values by testing for equality. But when extra
flexibility is required, you can specify
 [OCHamcrest](https://github.com/hamcrest/OCHamcrest) matchers.

```obj-c
// mock creation
NSMutableArray *mockArray = mock([NSMutableArray class]);

// using mock object
[mockArray removeObject:@"This is a test"];

// verification
[verify(mockArray) removeObject:startsWith(@"This is")];
```

OCHamcrest matchers can be specified as arguments for both verification and
stubbing.

Typed arguments will issue a warning that the matcher is the wrong type. Just
cast the matcher to `id`.


How do you specify matchers for non-object arguments?
-----------------------------------------------------

To stub a method that takes a non-object argument but specify a matcher, invoke
the method with a dummy argument, then call `-withMatcher:forArgument:`

```obj-c
[[given([mockArray objectAtIndex:0]) withMatcher:anything() forArgument:0]
 willReturn:@"foo"];
```

Use the shortcut `-withMatcher:` to specify a matcher for a single argument:

```obj-c
[[given([mockArray objectAtIndex:0]) withMatcher:anything()]
 willReturn:@"foo"];
```

These methods are also available to specify matchers for verification. Just call
them after `verify(…)` but before the invocation you want to verify:

```obj-c
[[verify(mockArray) withMatcher:greaterThan(@5])] removeObjectAtIndex:0];
```


Verifying exact number of invocations / at least x / never
----------------------------------------------------------

```obj-c
// using mock
[mockArray addObject:@"once"];

[mockArray addObject:@"twice"];
[mockArray addObject:@"twice"];

// the following two verifications work exactly the same
[verify(mockArray) addObject:@"once"];
[verifyCount(mockArray, times(1)) addObject:@"once"];

// verify exact number of invocations
[verifyCount(mockArray, times(2)) addObject:@"twice"];
[verifyCount(mockArray, times(3)) addObject:@"three times"];

// verify using never(), which is an alias for times(0)
[verifyCount(mockArray, never()) addObject:@"never happened"];

// verify using atLeast()/atMost()
[verifyCount(mockArray, atLeastOnce()) addObject:@"at least once"];
[verifyCount(mockArray, atLeast(2)) addObject:@"at least twice"];
[verifyCount(mockArray, atMost(5)) addObject:@"at most five times"];
```


Capturing arguments for further assertions
------------------------------------------

OCMockito verifies argument values using OCHamcrest matchers; non-matcher
arguments are implicitly wrapped in the `equalTo` matcher to test for equality.
In some situations though, it's helpful to capture an argument so you can send
it another message.

OCHamcrest provides a special matcher for this purpose: HCArgumentCaptor.
Specify it as an argument, then query it with either the `value` or `allValues`
properties.

For example, you may want to send the captured argument a message to query its
state:

```obj-c
HCArgumentCaptor *argument = [[HCArgumentCaptor alloc] init];
[verify(mockObject) doSomething:(id)argument];
assertThat([argument.value nameAtIndex:0], is(@"Jon"));
```

Capturing arguments is especially handy for block arguments. Capture the
argument, cast it to the block type, then invoke the block directly to simulate
the ways it will be called by production code:

```obj-c
HCArgumentCaptor *argument = [[HCArgumentCaptor alloc] init];
[verify(mockArray) sortUsingComparator:(id)argument];
NSComparator block = argument.value;
assertThat(@(block(@"a", @"z")), is(@(NSOrderedAscending)));
```


Stubbing consecutive calls
--------------------------

```obj-c
[[given([mockObject someMethod:@"some arg"])
    willThrow:[NSException exceptionWithName:@"name" reason:@"reason" userInfo:nil]]
    willReturn:@"foo"];

// First call: throws exception
[mockObject someMethod:@"some arg"];

// Second call: prints "foo"
NSLog(@"%@", [mockObject someMethod:@"some arg"]);

// Any consecutive call: prints "foo" as well. (Last stubbing wins.)
NSLog(@"%@", [mockObject someMethod:@"some arg"]);
```


Stubbing with blocks
--------------------

We recommend using simple stubbing with `willReturn:` or `willThrow:` only. But
`willDo:` using a block can sometimes be helpful. The block can easily access
invocation arguments by calling `mkt_arguments` from NSInvocation+OCMockito.h.
Whatever the block returns will be used as the stubbed return value.

```obj-c
[[given([mockObject someMethod:anything()]) willDo:^id (NSInvocation *invocation){
    NSArray *args = [invocation mkt_arguments];
    return @([args[0] intValue] * 2);
}];

// Following prints 4
NSLog(@"%@", [mockObject someMethod:@2]);
```

You can stub a void method with a block by using `givenVoid` instead of `given`.


Problems with dealloc
---------------------

Use `stopMocking(…)` if a `-dealloc` of your System Under Test is trying to
message an object that is mocked. It disables message handling on the mock and
frees its retained arguments. This prevents retain cycles and crashes during
test clean-up. See StopMockingTests.m for an example.
