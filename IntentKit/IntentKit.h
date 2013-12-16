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

/** A mish-mosh of occasionally-useful methods */
@interface IntentKit : NSObject

/** A static singleton object */
+ (instancetype)sharedInstance;

/** Determines whether or not the current device is an iPad.
 @return YES if being run on an iPad (UIUserInterfaceIdiomPad), otherwise no. */
- (BOOL)isPad;

/** An array of the current device's preferred languages. */
- (NSArray *)preferredLanguages;

@end
