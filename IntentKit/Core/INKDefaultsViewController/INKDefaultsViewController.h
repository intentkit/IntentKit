//
//  INKDefaultsViewController.h
//  IntentKitDemo
//
//  Created by Michael Walker on 2/27/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A view controller that lets users see and change each handler's default application. */
@interface INKDefaultsViewController : UITableViewController

/** A list of INKHandler subclasses (Class objects) to whitelist.
    If this is not set, the view controller will show every handler type that is currently installed. */
@property (strong, nonatomic) NSArray *allowedHandlers;

/** Instantiate an INKDefaultsViewController object with a given list of handlers to show.
 @param allowedHandlers An array of INKHandler subclasses (Class objects) to display
 @return An instantiated INKDefaultsViewController object */
- (id)initWithAllowedHandlers:(NSArray *)allowedHandlers;

@end
