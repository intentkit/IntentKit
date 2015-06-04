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

@interface INKPhoneHandler : INKHandler

- (INKActivityPresenter *)voiceCall:(NSString *)number;
- (INKActivityPresenter *)communicateWith:(NSString *)number;

@end
