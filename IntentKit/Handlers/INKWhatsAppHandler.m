//
//  INKMessageHandler.m
//  Pods
//
//  Created by Shane Whitehead on 23/12/2014.
//
//

#import "INKWhatsAppHandler.h"
#import "INKActivityPresenter.h"

@implementation INKWhatsAppHandler

- (INKActivityPresenter *)chat:(NSString *)abid withText:(NSString *)text {

	NSDictionary *args = @{ @"userid" : abid, @"text" : text };
	return [self performCommand:NSStringFromSelector(_cmd) withArguments:args];

}

@end
