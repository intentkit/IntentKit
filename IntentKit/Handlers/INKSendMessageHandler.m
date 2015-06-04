//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKSendMessageHandler.h"
#import "INKActivityPresenter.h"

@implementation INKSendMessageHandler

- (INKActivityPresenter *)sendText:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

-(INKActivityPresenter *)communicateWith:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];
	
}

@end
