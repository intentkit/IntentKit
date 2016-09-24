//
//  INKMessageHandler.h
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import <Foundation/Foundation.h>
#import "INKHandler.h"

@class INKSkypeHandler;

@interface INKSkypeHandler : INKHandler

- (INKActivityPresenter *)videCall:(NSString *)number;
- (INKActivityPresenter *)voiceCall:(NSString *)number;
- (INKActivityPresenter *)chatWith:(NSString *)number;

@end
