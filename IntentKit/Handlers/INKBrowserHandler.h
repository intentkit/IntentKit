//
//  INKBrowserHandler.h
//  IntentKit
//
//  Created by Michael Walker on 11/26/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKHandler.h"

@class INKActivityPresenter;

/** An instance of `INKBrowserHandler` opens http and https URLs in a third-party web browser. */
@interface INKBrowserHandler : INKHandler

/** Opens a URL 
 @param url A URL to open. Must have either `http:` or `https:` as its scheme. 
 @return A `INKActivityPresenter` object to present. */
- (INKActivityPresenter *)openURL:(NSURL *)url;

/** Opens a URL with a callback
 @param url A URL to open. Must have either `http:` or `https:` as its scheme.
 @param callback A URL to be opened by the third-party app when the action has been completed.
 @see openURL:
 @return A `INKActivityPresenter` object to present. */
- (INKActivityPresenter *)openURL:(NSURL *)url withCallback:(NSURL *)callback;

@end
