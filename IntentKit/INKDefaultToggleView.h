//
//  INKDefaultToggleView.h
//  IntentKitDemo
//
//  Created by Michael Walker on 12/18/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A view responsible for showing a 'set as default' toggle switch */
@interface INKDefaultToggleView : UIControl

/** Whether or not the choice should be saved as a default. */
@property (nonatomic, assign) BOOL isOn;

@end
