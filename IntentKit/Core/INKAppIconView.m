//
//  INKAppIconView.m
//  IntentKitDemo
//
//  Created by Michael Walker on 2/27/14.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import "INKAppIconView.h"
#import <UIView+MWLayoutHelpers.h>
#import "IntentKit.h"

CGFloat const INKActivityCellIconSize_Pad = 76.f;
CGFloat const INKActivityCellIconSize_Phone = 60.f;

static NSString *INKActivityCellIconMask = @"iconMask";
static NSString *INKActivityCellIconBorder = @"iconBorder";


@interface INKAppIconView ()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *iconBorder;
@end

@implementation INKAppIconView

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (!self) return nil;

    self.image = image;
    [self commonInit];

    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self commonInit];

    return self;
}

- (id)init {
    self = [super init];
    if (!self) return nil;

    [self commonInit];

    return self;
}

- (void)commonInit {
    CGFloat size = IntentKit.sharedInstance.isPad ?
    INKActivityCellIconSize_Pad : INKActivityCellIconSize_Phone;
    [self resizeTo:CGSizeMake(size, size)];

    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];

    self.iconBorder = [[UIImageView alloc] initWithFrame:self.bounds];
    self.iconBorder.image = [[IntentKit.sharedInstance imageNamed:INKActivityCellIconBorder]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconBorder.tintColor = [UIColor blackColor];
    [self addSubview:self.iconBorder];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    __weak UIImageView *imageView = self.imageView;
    [self maskImageWithCompletion:^(UIImage *maskedImage) {
        imageView.image = maskedImage;
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsLayout];
}

- (void)maskImageWithCompletion:(void(^)(UIImage *maskedImage))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        CGImageRef maskRef = [[IntentKit.sharedInstance imageNamed:INKActivityCellIconMask]CGImage];

        CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                            CGImageGetHeight(maskRef),
                                            CGImageGetBitsPerComponent(maskRef),
                                            CGImageGetBitsPerPixel(maskRef),
                                            CGImageGetBytesPerRow(maskRef),
                                            CGImageGetDataProvider(maskRef), NULL, false);
        CGImageRef maskedImageRef = CGImageCreateWithMask(self.image.CGImage, mask);
        CGFloat scale = UIScreen.mainScreen.scale;
        UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef scale:scale orientation:UIImageOrientationUp];
        CGImageRelease(mask);
        CGImageRelease(maskedImageRef);

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(maskedImage);
            }
        });
    });
}

@end
