//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKMessageHandler.h"
#import "INKActivityPresenter.h"

@implementation INKMessageHandler

- (INKActivityPresenter *)sendMessage:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

@end
