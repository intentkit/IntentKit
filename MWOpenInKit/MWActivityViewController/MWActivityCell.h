//
//  MWActivityCell.h
//  MWOpenInKitDemo
//
//  Created by Michael Walker on 12/9/13.
//  Copyright (c) 2013 Mike Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

/** A UICollectionViewCell representing a single application in a MWActivityViewController*/
@interface MWActivityCell : UICollectionViewCell

/** The underlying UIActivity */
@property (strong, nonatomic) UIActivity *activity;

@end
