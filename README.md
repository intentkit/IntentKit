MWOpenInKit [![Build Status](https://travis-ci.org/lazerwalker/MWOpenInKit.png)](https://travis-ci.org/lazerwalker/MWOpenInKit)
=========

MWOpenInKit is an easier way to handle third-party URL schemes in iOS apps.

![Example animation](https://raw.github.com/lazerwalker/MWOpenInKit/master/example.gif)


Linking to third-party apps is essentially broken on iOS. Let's say that, as a developer, you want to allow users to open map links in Google Maps instead of the built-in Maps.app. You now need to write a whole bunch of custom code that determines whether Google Maps is installed, ask the user which they would prefer, and ideally remember that preference.

If we take a more complex example, like Twitter clients, you're now potentially managing a dozen different third-party URL schemes that are all drastically different and quite possibly poorly-documented.

As a result, very few apps link to external third-party apps for tasks handled by Apple's easier-to-link-to apps, even when users prefer third-party apps.

MWOpenInKit attempts to solve this problem.

**For users**, it provides a beautiful selection interface to choose which third-party app to perform an action in.

**For developers**, it provides:

- An elegant, cohesive API based on semantic actions. Instead of manually constructing URLs, just tell it what you're trying to do. Instead of manually checking which applications a user has installed, let MWOpenInKit automatically query the device for you to figure out what applications are available to perform a given action.

- A unified, human-readable repository of third-party URL schemes. Every application's URL scheme is just a plaintext plist. You can add support for your application to MWOpenInKit without writing a single line of code.


Installation
------------
MWOpenInKit is easiest to install using [CocoaPods](http://cocoapods.org). Just add the following to your Podfile.

    pod "MWOpenInKit"


After running `pod install`, you should be able to `#import <MWOpenInKit/MWOpenInKit.h>` inside your application code and go to town.


Usage
-----
In its simplest form, to use MWOpenInKit you just need to instantiate a handler object, give it an action to perform, and tell the resulting presenter object to present itself. Here's how you'd open a URL in an external web browser on an iPhone:

```obj-c
NSURL *url = [NSURL URLWithString:@"http://google.com"]
MWBrowserHandler *browserHandler = [[MWBrowserHandler alloc] init];
MWActivityPresenter *presenter = [browserHandler openURL:url];
[presenter presentModalActivitySheetFromViewController:self];
```

If the user only has MobileSafari installed, this will open up Safari just as if you had called `[[UIApplication sharedApplication] openURL:url]`.

If the user has multiple web browsers installed, this will display a modal sheet (similar to the iOS 7-style `UIActivityViewController`) listing each of the available applications.

This will always display as a modal sheet, but if your app is Universal or iPad-only you probably want to display the application sheet as popover instead. The following code will automatically display itself modally on an iPhone and in a `UIPopoverController` on an iPad.

```obj-c
NSURL *url = [NSURL URLWithString:@"http://google.com"]
MWBrowserHandler *browserHandler = [[MWBrowserHandler alloc] init];
MWActivityPresenter *presenter = [browserHandler openURL:url];
[presenter presentActivitySheetFromViewController:self
                                  popoverFromRect:someRect
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
```

All of those options will be passed directly into a `UIPopoverController`. Similarly, there exists a `presentActivitySheetFromViewController:popoverFromBarButtonItem:permittedArrowDirections:animated:` that calls the equivalent `UIPopoverController` method if appropriate.


### Different Handlers
There are a number of different handler objects, all grouped by the type of application. For example, `MWBrowserHandler`, `MWMapsHandler`, and `MWTwitterHandler` handle opening links in web browsers, mapping applications, and Twitter clients, respectively.

Some of these handlers have optional configuration parameters. For example, when linking to a map application, you can specify where the map should be centered and how zoomed-in it should be; these options will take effect whether you're searching for a location, getting turn-by-turn directions, or doing any other action supported by the handler.

```obj-c
MWMapsHandler *mapsHandler = [[MWMapsHandler alloc] init];
mapsHandler.center = CLLocationCoordinate2DMake(42.523, -73.544);
mapsHandler.zoom = 14;
[mapsHandler directionsFrom:@"Washington Square Park" to:@"Lincoln Center"];
```

Here's where the real power of `MWOpenInKit` shines through. This gives you a clean, semantic API to construct links rather than having to manually cobble together URLs, regardless of whether your user wants to use Apple Maps or a third-party app.

An up-to-date list of available handlers and what methods and configuration options is available in the project's documentation.


Documentation
-------------
Exhaustive documentation (generated using [appledoc](https://github.com/tomaz/appledoc)) can be found in the `docs` directory by running `script/generate-docs.sh` from the root directory. Or viewed on [CocoaDocs](http://cocoadocs.org/docsets/MWOpenInKit/)


Example Project
---------------
A demo app has been provided so you can see MWOpenInKit in action.

1. Clone this repo.
2. Run `pod install` inside the project directory.
2. Open `MWOpenInKitDemo.xcworkspace`.
3. Build and run the app.

The demo lets you perform any of the actions supported by MWOpenInKit.

If you only have one app installed capable of performing a task, MWOpenInKit will by default open up that app directly rather than prompt the user to pick. In the demo app, there is a toggle to always show the selection UI. It's recommended that you run the demo on an actual iOS device that has third-party apps installed, but if you must run it in the simulator that toggle will let you see what the selection UI looks like.


Adding new URL Schemes
----------------------
Extending MWOpenInKit to include your own application's URL scheme is easy.

1. Inside the `/MWOpenKit/Apps/` directory, create a new directory with the name of your app.

2. Inside that directory, create a plist. Its name should be the name you want displayed, and it should contain a dictionary. Each key is the signature of a method in the appropriate `MWHandler` object, and the key is a template string used to generate a URL for that method, where variables wrapped in `{handlebars}` will be interpolated at runtime.

    As much as possible, the template variable keys are named the same as the parameter names of the corresponding Objective-C methods, but there's nothing enforcin that. I'd recommend looking at other plist files in the directory to see what the correct method keys and template keys are.

3. Your app's icon goes in the same directory. You will need four copies of the icon, all with the same root name as your plist file:
    * `AppName.png`: 60x60
    * `AppName@2x.png`: 120x120
    * `AppName-iPhone.png`: 76x76
    * `AppName-iPad@2x.png`: 152x152
    
    These will all be shown as-is, so they should be prerendered. The root filename ("AppName" in those examples) must exactly match the filename of the plist.

4. Open the example project in Xcode and run the tests (`Cmd+U`). This runs a linter which will let you know if any of the actions defined in your plist don't correspond to actual Objective-C handler methods, helping make sure you didn't make any typos.

    Note that you don't need to manually add any of the files to Xcode; they'll be picked up automatically. If you're seeing unexpected behavior and suspect your changes aren't taking effect, clean the project in Xcode, delete the derived data folder, and reset the simulator.

    You also probably want to run the example app on an actual iOS device to make sure your links all work as expected.

5. Submit a pull request!

If your application supports actions not currently represented in a handler, or is part of a class of applications that doesn't currently have a handler, you'll have to write code to add support. The current handler code is easy to read; refer to an existing handler subclass as a reference for creating your own handler methods or `MWHandler` subclasses.


Contributing
------------
At this point, the best way you can help out with `MWOpenInKit` is honestly to just use it in your applications and submit pull requests for your apps' URL schemes. That being said, any other contributions are welcome! Tests and documentation via appledocs are heavily encouraged for new code.


Roadmap
-------
The goal of the initial version of `MWOpenInKit` was just to create a simple way to integrate third-party app linking without a lot of boilerplate code. Here's a non-exhaustive list of ways it could be extended in to the future.

* Saving user app preferences, both on a per-app basis and (ideally) across all applications on a single device that use `MWOpenInKit`
* Support for localization in app names
* The ability to have handlers perform custom code instead of always opening a URL (e.g. showing a `MFMailComposeViewController` or an in-app web view)
* Downloading and caching plists at runtime, allowing an app to pull in the latest URL schemes without needing an App Store update
* A web-based CMS to add and manage URL schemes without needing to manually edit plists or submit pull requests.
* Optional downloading of app icons from Apple at runtime rather than requiring developers to upload them


Contact
-------
Mike Walker

- https://github.com/lazerwalker
- [@lazerwalker](http://twitter.com/lazerwalker)
- http://lazerwalker.com


License
-------
MWOpenInKit is available under the MIT license. See the LICENSE file for more info.
