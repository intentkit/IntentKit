//
//  INKMessageHandler.h
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import <Foundation/Foundation.h>
#import "INKHandler.h"

@class INKActivityPresenter;

@interface INKWhatsAppHandler : INKHandler

- (INKActivityPresenter *)chat:(NSString *)abid withText:(NSString *)text;

@end
