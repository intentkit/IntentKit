//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKMessangerHandler.h"
#import "INKActivityPresenter.h"

@implementation INKMessangerHandler

- (INKActivityPresenter *)textMessage:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

-(INKActivityPresenter *)communicateWithPhoneNumber:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];
	
}

@end
