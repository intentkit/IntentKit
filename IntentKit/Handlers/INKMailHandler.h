//
// Created by Arvid on 17/12/13.
// Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import "INKHandler.h"

@class INKActivityPresenter;

@interface INKMailHandler : INKHandler

@property (nonatomic, assign) NSString *subject;
@property (nonatomic, assign) NSString *messageBody;

- (INKActivityPresenter *)sendMailTo:(NSString *)recipient;

@end