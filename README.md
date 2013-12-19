IntentKit [![Build Status](https://travis-ci.org/intentkit/IntentKit.png)](https://travis-ci.org/intentkit/IntentKit)
=========

**ANNOUNCEMENT: MWOpenKit has been renamed! It is now known simply as [IntentKit](http://intentkit.github.io).**

IntentKit is an easier way to handle third-party URL schemes in iOS apps.

![Example animation](https://raw.github.com/intentkit/IntentKit/master/example.gif)


Linking to third-party apps is essentially broken on iOS. Let's say that, as a developer, you want to allow users to open map links in Google Maps instead of the built-in Maps.app. You now need to write a whole bunch of custom code that determines whether Google Maps is installed, ask the user which they would prefer, and ideally remember that preference.

If we take a more complex example, like Twitter clients, you're now potentially managing a dozen different third-party URL schemes that are all drastically different and quite possibly poorly-documented.

As a result, very few apps link to external third-party apps for tasks handled by Apple's easier-to-link-to apps, even when users prefer third-party apps.

IntentKit attempts to solve this problem.

**For users**, it provides a beautiful selection interface to choose which third-party app to perform an action in.

**For developers**, it provides:

- An elegant, cohesive API based on semantic actions. Instead of manually constructing URLs, just tell it what you're trying to do. Instead of manually checking which applications a user has installed, let IntentKit automatically query the device for you to figure out what applications are available to perform a given action.

- A unified, human-readable repository of third-party URL schemes. Every application's URL scheme is just a plaintext plist. You can add support for your application to IntentKit without writing a single line of code.


Installation
------------
IntentKit is easiest to install using [CocoaPods](http://cocoapods.org). Just add the following to your Podfile.

    pod "IntentKit"


After running `pod install`, you should be able to `#import <IntentKit/IntentKit.h>` inside your application code and go to town.


Usage
-----
In its simplest form, to use IntentKit you just need to instantiate a handler object, give it an action to perform, and tell the resulting presenter object to present itself. Here's how you'd open a URL in an external web browser on an iPhone:

```obj-c
NSURL *url = [NSURL URLWithString:@"http://google.com"]
INKBrowserHandler *browserHandler = [[INKBrowserHandler alloc] init];
INKActivityPresenter *presenter = [browserHandler openURL:url];
[presenter presentModalActivitySheetFromViewController:self];
```

If the user only has MobileSafari installed, this will open up Safari just as if you had called `[[UIApplication sharedApplication] openURL:url]`.

If the user has multiple web browsers installed, this will display a modal sheet (similar to the iOS 7-style `UIActivityViewController`) listing each of the available applications.

This will always display as a modal sheet, but if your app is Universal or iPad-only you probably want to display the application sheet as popover instead. The following code will automatically display itself modally on an iPhone and in a `UIPopoverController` on an iPad.

```obj-c
NSURL *url = [NSURL URLWithString:@"http://google.com"]
INKBrowserHandler *browserHandler = [[INKBrowserHandler alloc] init];
INKActivityPresenter *presenter = [browserHandler openURL:url];
[presenter presentActivitySheetFromViewController:self
                                  popoverFromRect:someRect
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
```

All of those options will be passed directly into a `UIPopoverController`. Similarly, there exists a `presentActivitySheetFromViewController:popoverFromBarButtonItem:permittedArrowDirections:animated:` that calls the equivalent `UIPopoverController` method if appropriate.


### Different Handlers
There are a number of different handler objects, all grouped by the type of application. For example, `INKBrowserHandler`, `INKMapsHandler`, and `INKTwitterHandler` handle opening links in web browsers, mapping applications, and Twitter clients, respectively.

Some of these handlers have optional configuration parameters. For example, when linking to a map application, you can specify where the map should be centered and how zoomed-in it should be; these options will take effect whether you're searching for a location, getting turn-by-turn directions, or doing any other action supported by the handler.

```obj-c
INKMapsHandler *mapsHandler = [[INKMapsHandler alloc] init];
mapsHandler.center = CLLocationCoordinate2DMake(42.523, -73.544);
mapsHandler.zoom = 14;
[mapsHandler directionsFrom:@"Washington Square Park" to:@"Lincoln Center"];
```

Here's where the real power of `IntentKit` shines through. This gives you a clean, semantic API to construct links rather than having to manually cobble together URLs, regardless of whether your user wants to use Apple Maps or a third-party app.

An up-to-date list of available handlers and what methods and configuration options is available in the project's documentation.


### Fallback URLs
If a user doesn't have any appropriate apps installed that can perform an action, IntentKit will try to use a web browser as a fallback. For example, if a user tries to do something involving Twitter but doesn't have any Twitter clients installed, IntentKit will try to load the appropriate `twitter.com` URL. It does this by presenting an `INKBrowserHandler` so the user can still pick their preferred web browser.

If you don't want this behavior, you can disable it by setting a handler's `useFallback` property to `NO` before invoking an action.

### Dealing With Defaults
When picking an app to use, IntentKit gives users the option to save that app as the default. That application will then be opened automatically every time that handler is presented. If a default app doesn't support a given action (for example, if a user has picked Twitter.app as their default Twitter client, but then tries to do something that only Tweetbot can do), the share sheet will be displayed as normal. In this case, the "Remember" toggle will be disabled.

It's good practice to let your users reset or change their preferences. IntentKit does not provide a user-facing way to do this, but it does expose two API methods you can use to integrate this into your app's own UI (e.g. in your app's settings page).

```obj-c
INKDefaultsManager *defaultsManager = [[INKDefaultsManager alloc] init];

// Forget the user's preferred Twitter client, but leave all other preferences intact
[defaultsManager removeDefaultForHandler:[INKTwitterHandler class]];

// Forget all user preferences
[defaultsManager removeAllDefaults];
```

Documentation
-------------
Documentation can be viewed online on [CocoaDocs](http://cocoadocs.org/docsets/IntentKit/).

Alternatively, documentation can be found in the `docs` directory by running `script/generate-docs.sh` from the root directory. If you do this, be aware that the documentation will be generated from your current copy of the code, which might differ from the most recent tagged version on CocoaPods.


Example Project
---------------
A demo app has been provided so you can see IntentKit in action.

1. Clone this repo.
2. Run `pod install` inside the project directory.
2. Open `IntentKitDemo.xcworkspace`.
3. Build and run the app.

The demo lets you perform any of the actions supported by IntentKit.

If you only have one app installed capable of performing a task, IntentKit will by default open up that app directly rather than prompt the user to pick. In the demo app, there is a toggle to always show the selection UI. It's recommended that you run the demo on an actual iOS device that has third-party apps installed, but if you must run it in the simulator that toggle will let you see what the selection UI looks like.


Adding new URL Schemes
----------------------
Extending IntentKit to include your own application's URL scheme is easy.

1. Inside the `IntentKit/Apps/` directory, create a new directory with the name of your app.

2. Inside that directory, create a plist. Its name should be the app's (English) name, and its root object should be a dictionary.

    Inside this dictionary, there should be a `name` key that represents the app's localized name(s). If your app's name does not change across locales, its value should be a string with that name.

    ```xml
    <key>name</key>
    <string>Safari</string>
    ```

     If it does change, the value should be a dictionary mapping [IETF BCP 47](https://tools.ietf.org/html/bcp47) language identifiers to localized names.

    ```xml
    <key>name</key>
    <dict>
      <key>en</key>
      <string>Sina Weibo</string>
      <key>zh-Hans</key>
      <string>新浪微博</string>
    </dict>
    ```

    Additionally, there should be an `actions` dictionary containing all of the actions your application can perform. This dictionary should map strings representing `INKHandler` methods to template strings used to generate URLs for those method. In these template strings, variables wrapped in {handlebars} will be interpolated at runtime. For example:

    ```xml
    <key>actions</key>
    <dict>
        <key>searchForLocation:</key>
        <string>comgooglemaps://?q={query}</string>
    </dict>
    ```

    In general, the template variable keys are named the same as the argument names of the corresponding handler methods, but there is currently nothing enforcing that. It's recommended that you look at the plist files for other apps that respond to the same actions to see what the correct template keys are.

3. Your app's icon goes in the same directory. You will need four copies of the icon, all with the same root name as your plist file:
    * `AppName.png`: 60x60
    * `AppName~ipad.png`: 76x76
    * `AppName@2x.png`: 120x120
    * `AppName@2x~ipad.png`: 152x152

    Use the same square icons you're using in your app's Xcode project; IntentKit will take care of masking them so they appear as iOS-style rounded rectangles/superellipses. The root filename ("AppName" in those examples) must exactly match the filename of the plist.

4. Open the example project in Xcode and run the tests (`Cmd+U`). This runs a linter which will let you know if any of the actions defined in your plist don't correspond to actual Objective-C handler methods, helping make sure you didn't make any typos.

    Note that you don't need to manually add any of the files to Xcode; they'll be picked up automatically. If you're seeing unexpected behavior and suspect your changes aren't taking effect, clean the project in Xcode, delete the derived data folder, and reset the simulator.

    You also probably want to run the example app on an actual iOS device to make sure your links all work as expected.

5. Submit a pull request!

If your application supports actions not currently represented in a handler, or is part of a class of applications that doesn't currently have a handler, you'll have to write code to add support. The current handler code is easy to read; refer to an existing handler subclass as a reference for creating your own handler methods or `INKHandler` subclasses.


Contributing
------------
All contributions are welcome! If you want to help but don't know where to begin, adding in support for a new third-party application can be a great way to get started (it typically doesn't require writing any code).

Tests and documentation are heavily encouraged for new code. We use [appledoc](http://gentlebytes.com/appledoc/) for documentation and [Specta](https://github.com/specta/specta)) for tests.


Roadmap
-------
The goal of the initial version of `IntentKit` was just to create a simple way to integrate third-party app linking without a lot of boilerplate code. Here's a non-exhaustive list of ways it could be extended in to the future.

* The ability to have handlers perform custom code instead of always opening a URL (e.g. showing a `MFMailComposeViewController` or an in-app web view)
* Downloading and caching plists at runtime, allowing an app to pull in the latest URL schemes without needing an App Store update
* A web-based CMS to add and manage URL schemes without needing to manually edit plists or submit pull requests.
* Saving user app preferences across all applications on a single device that use IntentKit
* Optional downloading of app icons from Apple at runtime rather than requiring developers to upload them


Contact
-------
Mike Walker

- https://github.com/lazerwalker
- [@lazerwalker](http://twitter.com/lazerwalker)
- http://lazerwalker.com

The initial version of IntentKit was built at [Hacker School](http://hackerschool.com).

License
-------
IntentKit is available under the MIT license. See the LICENSE file for more info.
