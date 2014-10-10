IntentKit [![Build Status](https://travis-ci.org/intentkit/IntentKit.png)](https://travis-ci.org/intentkit/IntentKit)
=========

IntentKit is an easier way to handle third-party URL schemes in iOS apps.

![Example of activity view](https://raw.github.com/intentkit/IntentKit/master/example.gif)


Linking to third-party apps is essentially broken on iOS. Let's say that, as a developer, you want to allow users to open map links in Google Maps instead of the built-in Maps.app. You now need to write a whole bunch of custom code that determines whether Google Maps is installed, ask the user which they would prefer, and ideally remember that preference.

If we take a more complex example, like Twitter clients, you're now potentially managing a dozen different third-party URL schemes that are all drastically different and quite possibly poorly-documented.

As a result, very few apps link to external third-party apps for tasks handled by Apple's easier-to-link-to apps, even when users prefer third-party apps.

IntentKit attempts to solve this problem.

**For users**, it provides a beautiful selection interface to choose which third-party app to perform an action in.

**For developers**, it provides:

- An elegant, cohesive API based on semantic actions. Instead of manually constructing URLs or creating modal view controllers to display, just tell it what you're trying to do. Instead of manually checking which applications a user has installed, let IntentKit automatically query the device for you to figure out what applications are available to perform a given action.

- A unified, human-readable repository of third-party URL schemes. Every application's URL scheme is just a plaintext plist. You can add support for your application to IntentKit without writing a single line of code.


Installation
------------
IntentKit is easiest to install using [CocoaPods](http://cocoapods.org). Just add the following to your Podfile.

    pod "IntentKit"


After running `pod install`, you should be able to #import any INKHandler header file (e.g. `#import <INKMailHandler.h>`) and go to town.

If you're concerned about the increase in your app bundle's size, you can choose to only include a subset of IntentKit's supported applications. Subspecs exist for each handler class.

    # Only includes web browsers
    pod "IntentKit/Browsers"

For more information on what subspecs are available, refer to the project's [Podspec](https://github.com/intentkit/IntentKit/blob/master/IntentKit.podspec).


Usage
-----

To use IntentKit, you start by instantiating a handler object. There are a handful of handler objects that come with IntentKit, each with domain knowledge of a specific type of application. For example, `INKBrowserHandler`, `INKMapsHandler`, and `INKTwitterHandler` handle opening links in web browsers, mapping applications, and Twitter clients, respectively.

After creating a new handler object, you just tell it what action you want to perform. It will return you a special object called a presenter, which can be used to actually perform the action. Here's how you'd open an email compose screen on an iPhone:

```obj-c
INKMailHandler *mailHandler = [[INKMailHandler alloc] init];
[[mailHandler sendMailTo:@"steve@apple.com"] presentModally];
```

If the user doesn't have any third-party mail apps installed (such as Mailbox or Google's native Gmail app), this will display an in-line `MFMailComposeViewController`, just as if you had created and presented one yourself. If the user does have other mail apps installed, this will display a modal sheet that looks like a `UIActivityViewController` listing each available application. It will also give them a switch they can tap to remember their choice for all future links of that type.


### "Convention Over Configuration" mode
Depending on your application and userbase, that user experience might not be ideal. If 99% of your users want to use the Apple default, why should they have to go through an extra tap?

Each `INKHandler` object has an `useSystemDefault` property. If you set it to `YES`, performing an INKHandler action will not result in a custom UI being shown. Instead, the system will silently pick an application to handle the request. Sensible defaults are picked for each handler type: all handlers that have an Apple-provided application will use that one, and handlers that are based on a third-party service (e.g. Twitter) will default to using the first-party application.

If you use this method of presenting IntentKit, it's recommended that you give users a way to set their own defaults. IntentKit provides a view controller called `INKDefaultsViewController` that lets users set preferences. Just create a new `INKDefaultsViewController` object, optionally limit which handler types should be displayed, and present it on-screen:

```obj-c
INKDefaultsViewController *defaultsController = [[INKDefaultsViewController alloc] init];
defaultsController.allowedHandlers = @[[INKBrowserHandler class], [INKMailHandler class]];
[self pushViewController:defaultsController animated:YES];
```

When you don't manually limit the handler types, it looks something like this:

![Example of defaults selector](https://raw.github.com/intentkit/IntentKit/master/example-defaults.gif)

If you'd rather more control over the user experience, IntentKit also offers API hooks to set your own defaults. Every INKHandler object has a `promptToSetDefault` method that will return an `INKActivityPresenter` object that handles prompting the user to select an application. For even lower-level control, the `INKApplicationList` and `INKDefaultsManager` classes can be used to fetch a list of available applications and manually set defaults.


### Optional Parameters
Some handlers have optional configuration parameters. For example, when linking to a map application, you can specify where the map should be centered and how zoomed-in it should be; these options will take effect whether you're searching for a location, getting turn-by-turn directions, or doing any other action supported by the handler.

```obj-c
INKMapsHandler *mapsHandler = [[INKMapsHandler alloc] init];
mapsHandler.center = CLLocationCoordinate2DMake(42.523, -73.544);
mapsHandler.zoom = 14;
[mapsHandler directionsFrom:@"Washington Square Park" to:@"Lincoln Center"];
```

This is where the real power of `IntentKit` shines through. This gives you a clean, semantic API to construct links rather than having to manually cobble together URLs, regardless of whether your user wants to use Apple Maps or a third-party app.

An up-to-date list of available handlers and what methods and configuration options is available in the project's documentation.


### Explicitly specifying the view controller
If you're using `presentModally`, it will attempt to intelligently figure out which view controller to present itself on. It's possible it won't pick the correct one automatically; if that's the case, you probably want to explicitly specify the correct view controller.

```obj-c
NSURL *url = [NSURL URLWithString:@"http://google.com"]
INKBrowserHandler *browserHandler = [[INKBrowserHandler alloc] init];
INKActivityPresenter *presenter = ][browserHandler openURL:url];
[presenter presentModalActivitySheetFromViewController:self];
```


### iPad and UIPopoverController
If your app is Universal or iPad-only, if you're displaying an IntentKit `INKActivityViewController` you probably want to display it as a popover instead of a modal sheet. The following code will automatically display itself modally on an iPhone and in a `UIPopoverController` on an iPad.

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

All of those options will be passed directly into a UIPopoverController. Similarly, there exists a `presentActivitySheetFromViewController:popoverFromBarButtonItem:permittedArrowDirections:animated:` method that calls the equivalent UIPopoverController method if appropriate.


### Fallback URLs
If a user doesn't have any appropriate apps installed that can perform an action, IntentKit will try to use a web browser as a fallback. For example, if a user tries to do something involving Twitter but doesn't have a Twitter client installed, IntentKit will try to load the appropriate `twitter.com` URL. It does this by presenting an `INKBrowserHandler` so the user can still pick their preferred web browser.

If you don't want this behavior, you can disable it by setting a handler's `useFallback` property to `NO` before invoking an action.


### Safari and UIWebViews
It's worth mentioning that IntentKit's default web browser is an in-app modal UIWebView. This is true both for actions triggered by an `INKBrowserHandler` and actions triggered by other handlers falling back to a web URL. If you don't want to do that, and would rather fall back on Safari for web actions, you can set your handler's `disableInAppOption` property to `NO`.


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

If you only have one app installed capable of performing a task, IntentKit will by default open up that app directly rather than prompt the user to pick. In the demo app, there is a toggle to always show the selection UI if there is at least one application available. It's recommended that you run the demo on an actual iOS device that has third-party apps installed, but if you must run it in the simulator that toggle will let you see what the selection UI looks like.


Adding Your Own Actions
----------------------
Extending IntentKit is easy.

#### Including your own URL Scheme

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

    Additionally, there should be an `actions` dictionary containing all of the actions your application can perform. This dictionary should map strings representing `INKHandler` methods to template strings used to generate URLs for those method. In these template strings, variables wrapped in [Mustache](http://mustache.github.io)-style curly braces will be interpolated at runtime. Just like Mustache, variables wrapped in double-braces (`{{name}}`) will be URL-escaped, whereas ones wrapped in triple-braces (`{{{url}}}`) will not be. For example:

    ```xml
    <key>actions</key>
    <dict>
        <key>searchForLocation:</key>
        <string>comgooglemaps://?q={{query}}</string>
    </dict>
    ```

    In general, the template variable keys are named the same as the argument names of the corresponding handler methods, but there is currently nothing enforcing that. It's recommended that you look at the plist files for other apps that respond to the same actions to see what the correct template keys are.

If your application supports actions not currently represented in a handler, or is part of a class of applications that doesn't currently have a handler, you'll have to write code to add support. The current handler code is easy to read; refer to an existing handler subclass as a reference for creating your own handler methods or `INKHandler` subclasses.

3. Your app's icon goes in the same directory. You will need four copies of the icon, all with the same root name as your plist file:
    * `AppName.png`: 60x60
    * `AppName~ipad.png`: 76x76
    * `AppName@2x.png`: 120x120
    * `AppName@2x~ipad.png`: 152x152

    Use the same square icons you're using in your app's Xcode project; IntentKit will take care of masking them so they appear as iOS-style rounded rectangles/superellipses. The root filename ("AppName" in those examples) must exactly match the filename of the plist.

4. In the root of your IntentKit codebase, run `pod install`. This will cause XCode to pick up any new files you've added. Next, run `rake` to run the test suite, which includes a linter to make sure that every action you've defined in your plist corresponds to a valid handler action. You'll also probably want to run the example app on an actual iOS device to make sure your links all work as expected.

5. In `IntentKit.podspec`, add your app to the subspec that corresponds to the handler your application responds to. Just add your app's folder name to the list of other application folder names in the appropriate resource bundle file glob.

6. Submit a pull request!


#### Including Your Own In-App View Controller

Adding your own modal in-app action is very similar to adding your own URL scheme, with a few exceptions.

All presentable IntentKit activities must conform to the `INKPresentable` protocol, which defines two methods: one which returns whether or not it can perform a given action, and tells it to actually perform an action. The latter method is passed a view controller to present your view controller modally on; it should both present your view controller, and take care of dismissing it once your action is complete.

A few other changes must be made to your application's IntentKit plist file:

1. `actions` should be an array of action names, rather than a dictionary.

2. There should be a field called `className` that lists the name of your `INKPresententable` class.

3. The `name` field should refer to whatever you want the activity to be listed as inside the app. For example, `INKMailSheet` (the activity that displays a MFMailComposeViewController) has a `name` of "In App".



Requirements
------------
IntentKit requires Xcode 5, targeting iOS 7.0 and above.


Contributing
------------
All contributions are welcome! If you want to help but don't know where to begin, adding in support for a new third-party application can be a great way to get started (it typically doesn't require writing any code).

Tests and documentation are heavily encouraged for new code. We use [appledoc](http://gentlebytes.com/appledoc/) for documentation and [Specta](https://github.com/specta/specta)) for tests.


Roadmap
-------
The goal of the initial version of `IntentKit` was just to create a simple way to integrate third-party app linking without a lot of boilerplate code. Here's a non-exhaustive list of ways it could be extended in to the future.

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
