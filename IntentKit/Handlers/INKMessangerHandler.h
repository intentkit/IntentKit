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

@interface INKMessangerHandler : INKHandler

- (INKActivityPresenter *)textMessage:(NSString *)number;
- (INKActivityPresenter *)communicateWithPhoneNumber:(NSString *)number;

@end
