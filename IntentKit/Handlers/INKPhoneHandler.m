//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKPhoneHandler.h"
#import "INKActivityPresenter.h"

@implementation INKPhoneHandler

- (INKActivityPresenter *)voiceCall:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

- (INKActivityPresenter *)communicateWith:(NSString *)number {
	
	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];
	
}

@end
