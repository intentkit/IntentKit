//
//  MWOpenInKit.h
//  Pods
//
//  Created by Michael Walker on 12/3/13.
//
//

#import "MWActivity.h"
#import "MWBrowserHandler.h"
#import "MWMapsHandler.h"
#import "MWTwitterHandler.h"

/** A mish-mosh of occasionally-useful global (uh-oh!) methods */
@interface MWOpenInKit : NSObject

/** Determines whether or not the current device is an iPad.
 @return YES if being run on an iPad (UIUserInterfaceIdiomPad), otherwise no. */
+ (BOOL)isPad;
@end
