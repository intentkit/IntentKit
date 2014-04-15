//
//  INKMailSheet.h
//  Pods
//
//  Created by Michael Walker on 4/15/14.
//
//

#import <Foundation/Foundation.h>

@interface INKMailSheet : NSObject

- (id)initWithAction:(NSString *)action params:(NSDictionary *)params;
- (void)presentInViewController:(UIViewController *)presentingViewController;

@end
