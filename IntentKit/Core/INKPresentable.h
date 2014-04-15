//
//  INKPresentable.h
//  Pods
//
//  Created by Michael Walker on 4/15/14.
//
//

@protocol INKPresentable <NSObject>

- (void)performAction:(NSString *)action
               params:(NSDictionary *)params
     inViewController:(UIViewController *)presentingViewController;

@end
