MWOpenInKit [![Build Status](https://travis-ci.org/lazerwalker/MWOpenInKit.png)](https://travis-ci.org/lazerwalker/MWOpenInKit)
=========

MWOpenInKit is an easier way to handle third-party URL schemes in iOS apps.

![Example animation](https://raw.github.com/lazerwalker/MWOpenInKit/master/example.gif)


Linking to third-party apps is essentially broken on iOS. Let's say that, as a developer, you want to allow users to open map links in Google Maps instead of the built-in Maps.app. You now need to write a whole bunch of custom code that determines whether Google Maps is installed, ask the user which they would prefer, and ideally remember that preference.

If we take a more complex example, like Twitter clients, you're now potentially managing a dozen different third-party URL schemes that are all drastically different and most likely poorly-documented.

As a result, very few apps link to external third-party apps for tasks handled by Apple's easier-to-link-to apps, even when users prefer third-party apps.

MWOpenInKit attempts to solve this problem.

**For users**, it provides a beautiful selection interface to choose which third-party app to perform an action in.

**For developers**, it provides:

- An elegant, cohesive API based on semantic actions. Instead of manually constructing URLs, just tell it what you're trying to do. Instead of manually checking which applications a user has installed, let MWOpenInKit automatically query the device for you to figure out what applications are available to perform a given action.

- A unified, human-readable repository of third-party URL schemes. Every application's URL scheme is just a plaintext plist. You can add support for your application to MWOpenInKit without writing a single line of code.


Installation
------------
MWOpenInKit is easy to install using [CocoaPods](http://cocoapods.org). Just add the following to your Podfile.

    pod "MWOpenInKit"


After running `pod install`, you should be able to `#import <MWOpenInKit/MWOpenInKit.h>` inside your application code and go to town.

It's not currently possible to install MWOpenInKit without CocoaPods.


**IMPORTANT**

MWOpenInKit hasn't actually been published to CocoaPods yet. For now, if you want to use MWOpenInKit, clone this repo and point your Podfile to the checked-out copy using the `:path` specifier:

    pod "MWOpenInKit", :path => "/some/path/to/MWOpenInKit"

This README will be updated when that changes.


Usage
-----
In its simplest form, to use MWOpenInKit you just need to instantiate a handler object and then tell it an action to perform. Here's how you'd open a URL in an external web browser:

```obj-c
MWBrowserHandler *browserHandler = [[MWBrowserHandler alloc] init];
[browserHandler openURL:[NSURL urlWithString:@"http://google.com"]];
```

If the user only has MobileSafari installed, `[browserHandler openURL:]` will open up Safari for you, just like if you had called `[[UIApplication sharedApplication] openURL:]` directly.

If the user has multiple web browsers installed, `[browserHandler openURL:]` will return a UIActivityViewController to be presented (per [Apple's documentation](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIActivityViewController_Class/Reference/Reference.html), it's recommended you present it modally on iPhone and in a UIPopoverController on iPad). When the user selects an app, it will automatically be updated.


There are a number of different handler objects, all grouped by the type of application. For exampe, MWBrowserHandler, MWMapsHandler, and MWTwitterHandler handle opening links in web browsers, mapping applications, and Twitter clients, respectively.

Some handlers have optional configuration parameters. For example, when linking to a map application, you can specify where the map should be centered and how zoomed-in it should be; these options will take effect whether you're searching for a location, getting turn-by-turn directions, or doing any other action supported by the handler.

```obj-c
MWMapsHandler *mapsHandler = [[MWMapsHandler alloc] init];
mapsHandler.center = CLLocationCoordinate2DMake(42.523, -73.544);
mapsHandler.zoom = 14;
[mapsHandler directionsFrom:@"Washington Square Park" to:@"Lincoln Center"];
```

For an up-to-date list of available handlers and what methods and configuration options are supported by each, check the documentation in the `docs` directory.


Documentation
-------------
Exhaustive documentation (generated using [appledoc](https://github.com/tomaz/appledoc)) can be found in the `docs` directory.


Example Project
---------------
A demo app has been provided so you can see MWOpenInKit in action.

1. Clone this repo
2. Run `pod install` to fetch dependencies
3. Open `MWOpenInKitDemo.xcworkspace`
4. Build and run the app

The demo lets you perform any of the actions supported by MWOpenInKit.

If you only have one app installed capable of performing a task, MWOpenInKit will by default open up that app directly rather than prompt the user to pick. In the demo app, there is a toggle to always show the selection UI. It's recommended that you run the demo on an actual iOS device that has third-party apps installed, but if you must run it in the simulator that toggle will let you see what the selection UI looks like.


Adding new URL Schemes
----------------------
Extending MWOpenInKit to include your own application's URL scheme is easy.

1. Create a new .plist file inside the appropriate directory inside the `MWOpenInKit/` folder. For example, the `Web Browsers` folder contains (surprise) plists for web browser applications. The name of the plist is the name that will be displayed.

2. The plist should contain a dictionary. Each key is the signature of a method in the appropriate `MWHandler` object, and the key is a template string used to generate a URL for that method, where variables wrapped in `{handlebars}` will be interpolated at runtime. For now, I'd recommend looking at other plist files in the directory to see what the correct method keys and template keys are.

3. Your app's icon goes in the `icons` folder in the same directory. You will need four copies of the icon, all with the same root name as your plist file:

- `AppName.png`: 60x60
- `AppName@2x.png`: 120x120
- `AppName-iPhone.png`: 76x76
- `AppName-iPad@2x.png`: 152x152

These will all be shown as-is, so they should be prerendered.

4. Submit a pull request! There is no need to manually add any of the files to Xcode.

Make sure to try it out first using the demo app to make sure that it works. If this project becomes sufficiently popular, it is likely I'll build a linting tool.


Contact
-------
Mike Walker

- https://github.com/lazerwalker
- [@lazerwalker](http://twitter.com/lazerwalker)
- http://lazerwalker.com


License
-------
MWOpenInKit is available under the MIT license. See the LICENSE file for more info.