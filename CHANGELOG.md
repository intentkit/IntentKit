## 0.5.2

###### Bugfixes
* Fixes a regression causing Fallback URLs to not work as expected.

## 0.5.1

###### Enhancements

* The README now indicates the new behavior for importing header files into your
  project (namely, that you need to manually import headers for each used INKHandler
  subclass rather than the generic `<IntentKit/IntentKit.h>`.

###### Bugfixes
* Localizations are now included in their own pregenerated bundle, fixing a bug
causing a random localization to be selected regardless of user language preferences.


## 0.5

###### Enhancements
* Each INKHandler now has a `useSystemDefault` option, which uses a default
application instead of displaying the selection sheet.
* In tandem with the `useSystemDefault` option, there is now an
`INKDefaultsViewController` class that displays a selection interface for
users to set preferences for each application type.
* The Twitter handler now supports a `sendDirectMessageToScreenName:` action
  [Jeff Blagdon](https://github.com/jefflovejapan) [#31](https://github.com/intentkit/IntentKit/pull/31)
* Dutch localizations are now present
  [Arno Moonen](https://github.com/itavero) [#33](https://github.com/intentkit/IntentKit/pull/33)

###### Refactors
* In order to make the `useSystemDefault` option viable, a lot of new properties
have been exposed on `INKHandler` and `INKApplicationList`.
* The demo/development Xcode project now loads in the library as a local CocoaPod,
making development easier as the dev environment now more closely resembles
production usage.
* Manual view layout is now done using the [MWLayoutHelpers](http://github.com/lazerwalker/mwlayouthelpers) CocoaPod (it
  was formerly using a copy of it manually copy/pasted into the project)
* The "IntentKit/Browsers" subspec no longer exists; it's now included by default into the core.

###### Bugfixes
* The new Twitter URL scheme for "mentions" now works.
[Jeff Blagdon](https://github.com/jefflovejapan) [#29](https://github.com/intentkit/IntentKit/pull/29)
* Fix a number of regressions related to icons and application plists not being properly included in subspecs
* The README now specifies that iOS 7 is required
[Brady Archambo](https://github.com/bradya) [#29](https://github.com/intentkit/IntentKit/pull/28)

## 0.4.1

###### Bugfixes
* Fixed a critical regression from 0.4.0 that caused icons to not show up.

## 0.4.0

###### Enhancements
* CocoaPods subspecs now exist to let you include just the handlers you need

###### Bugfixes
* A handful of subtle bugs were fixed related to IntentKit unintentionally
  damaging the view hierarchy when presenting an activity sheet
* String localization (for the "remember my choice" toggle) now works properly
  when loaded as a CocoaPod


## 0.3.0

###### Enhancements

* User preferences can now be saved on a per-handler basis
* Square app icons are masked at run-time, instead of requiring pre-masked icons
* Application names may be localized
* For actions where a user may not have an appropriate app installed, fallback
  URLs exist to perform the action in a web browser

###### New Handlers / Applications
* INKMailHandler, to send email (Mail.app, Gmail)
  [Arvid Gerstmann](https://github.com/Leandros) [#16](https://github.com/intentkit/IntentKit/pull/16)
* INKFacebookHandler and INKGPlusHandler, for Facebook and Google+
  [Arvid Gerstmann](https://github.com/Leandros) [#12](https://github.com/intentkit/IntentKit/pull/12)

###### Refactors
* Icons now use the `~icon` naming convention, simplifying image displaying code
* Handlebar templating has been abstracted out in the NSString+Helpers category
* Responsibility for auto-opening an app or showing an activity sheet has been
  moved from INKActivityPresenter to INKHandler

###### Bugfixes
* The activity sheet no longer affects other in-app modal dialogs
  [#18](https://github.com/intentkit/IntentKit/issues/18)

## 0.2.0

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
