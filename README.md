OpenInKit
---------
One of the weaker spots in Apple's iOS development ecosystem is linking from one third-party app to another. Even though there may be many applications on a user's phone that can perform similar tasks (e.g. mail clients, web browsers), each individual application must present its own unique URL scheme. As a result, there historically hasn't been a good way for users to set a third-party app as the default application for things like web browsing or mapping.

Even worse, very few apps even provide the option of linking to non-Apple apps, since non-trivial development work is required to support it. Let's say you want to allow users to open map links in Google Maps instead of the built-in Maps.app. You now need to write a whole bunch of custom code that determines whether Google Maps is installed, ask the user which they would prefer, and ideally remember that preference. It gets even more out-of-hand when you start dealing with something like Twitter clients, where you're potentially managing a dozen different third-party URL schemes that are all drastically different and most likely poorly-documented.

OpenInKit attempts to solve this problem in a number of ways.

**For users**, it provides a standardized interface to choose which third-party app they want to open a link in.

**For developers**, it provides an elegant, unified API based on semantic actions. It also enables easy addition and modification of third-party URL schemes by declaring each app's URL scheme in its own plist file; the hope is that the list of supported URL schemes will be maintained by the community, similar to CocoaPods podspec files.


**There's not yet much to see here. I'd recommend coming back later.**


Installation
============
OpenInKit is easiest to set up using CocoaPods. But not yet.


Usage
=====
OpenInKit provides a handful of different classes, each one designed to handle a specific type of resource.

As an example, this is how you would open a HTTP or HTTPS URL in a web browser (currently either Mobile Safari or Google Chrome):

    OKBrowserHandler *browserHandler = [[OKBrowserHandler alloc] init];
    [browserHandler openURL:[NSURL urlWithString:@"http://google.com"]];

If the user has Google Chrome installed, a UIActivityViewController will be displayed asking them to select between Mobile Safari and Chrome. If the user does not have Chrome installed, the link will just open in Mobile Safari as normal.

Web sites are fairly simple; for a more instructive example, here is how to get turn-by-turn driving directions in either Apple Maps or Google Maps:

    OKMapsHandler *mapsHandler = [[OKMapsHandler alloc] init];
    mapsHandler.center = CLLocationCoordinate2DMake(42.523, -73.544);
    mapsHandler.zoom = 14;
    [mapsHandler directionsFrom:@"Washington Square Park" to:@"Lincoln Center"];

`center` and `zoom` are both optional and may be omitted.