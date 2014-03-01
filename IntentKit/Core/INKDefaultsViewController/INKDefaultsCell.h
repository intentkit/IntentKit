//
//  INKDefaultsCell.h
//  IntentKitDemo
//
//  Created by Michael Walker on 2/27/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A cell detailing the default application of a given INKHandler subclass */
@interface INKDefaultsCell : UITableViewCell

/** The INKHandler subclass being represented by the cell. */
@property (strong, nonatomic) Class handlerClass;

/** If true, the data being shown represents a web browser fallback */
@property (readonly) BOOL isUsingFallback;

@end
