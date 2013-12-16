//
//  IntentKit.h
//  Pods
//
//  Created by Michael Walker on 12/3/13.
//
//

#import "INKActivity.h"
#import "INKBrowserHandler.h"
#import "INKMapsHandler.h"
#import "INKTwitterHandler.h"
#import "INKActivityPresenter.h"
#import "INKActivityViewController.h"

/** A mish-mosh of occasionally-useful global (uh-oh!) methods */
@interface IntentKit : NSObject

/** Determines whether or not the current device is an iPad.
 @return YES if being run on an iPad (UIUserInterfaceIdiomPad), otherwise no. */
+ (BOOL)isPad;
@end
