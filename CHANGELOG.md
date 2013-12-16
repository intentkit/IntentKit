## 0.2

**BREAKING CHANGE** MWOpenInKit is now called IntentKit!

If you were previously using MWOpenInKit, the interface is the same, except
everything has been renamed. Specifically:

* The pod name is now "IntentKit"
* The header file containing all includes is now `IntentKit.h`
* The class prefix for all files is now "INK" (e.g. `INKMapsHandler` instead of
  `MWMapsHandler`
* The git/GitHub repo is now located at `https://github.com/intentkit/IntentKit[.git]`.
* There is a landing page at http://intentkit.github.io

###### Bug Fixes

* Long app names (e.g. Google Maps) are no longer truncated on the iPhone
  https://github.com/lazerwalker/MWOpenInKit/commit/67707307ae0c675bbe980f6c09842a491a2f21bd


## 0.1.1

###### Enhancements

* There is now a changelog!

###### Refactor

* All application plists now store their available URLs inside an `actions`
  dictionary instead of the root of the plist.

###### Bug Fixes

* A quick reversion of a very bad bug that caused icons to not be tappable.


## 0.1.0

First public release!
