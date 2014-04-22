//
//  INKPresentable.h
//  Pods
//
//  Created by Michael Walker on 4/15/14.
//
//

/** A protocol that indicates a class represents a presenter object that can render a modal view controller to perform an action. */
@protocol INKPresentable <NSObject>

/** Check whether or not the presenter is available to perform a given action
 @param action The action to perform
 @return BOOL Whether or not the presenter is capable of performing the given action.   */
- (BOOL)canPerformAction:(NSString *)action;

/** Present a modal view controller to perform some action. 
 @param action A string representing an action to perform
 @param params A dictionary of parameters the action takes
 @param presentingViewController A view controller to modally present the new view controller on. Presumably, subclasses will at some point in this method call presentingViewController's `presentViewController:animated:completion:` method.
 
 @warning It is expected that after this class presents a modal view controller in this method, it will also be responsible for dismissing it when appropriate. */
- (void)performAction:(NSString *)action
               params:(NSDictionary *)params
     inViewController:(UIViewController *)presentingViewController;

@end
