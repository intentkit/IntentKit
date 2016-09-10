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

@interface INKMessageHandler : INKHandler

- (INKActivityPresenter *)sendMessage:(NSString *)number;

@end
