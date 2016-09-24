//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKSkypeHandler.h"
#import "INKActivityPresenter.h"

@implementation INKSkypeHandler

- (INKActivityPresenter *)videCall:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

- (INKActivityPresenter *)voiceCall:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

- (INKActivityPresenter *)chatWith:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

@end
