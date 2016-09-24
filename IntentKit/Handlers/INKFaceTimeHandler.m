//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKFaceTimeHandler.h"
#import "INKActivityPresenter.h"

@implementation INKFaceTimeHandler

- (INKActivityPresenter *)videoCall:(NSString *)number {

	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

- (INKActivityPresenter *)communicateWithPhoneNumber:(NSString *)number {
	
	NSDictionary *args = @{ @"number" : number };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];
	
}

@end
