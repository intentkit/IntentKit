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

@interface INKSendMessageHandler : INKHandler

- (INKActivityPresenter *)sendText:(NSString *)number;
- (INKActivityPresenter *)communicateWith:(NSString *)number;

@end
