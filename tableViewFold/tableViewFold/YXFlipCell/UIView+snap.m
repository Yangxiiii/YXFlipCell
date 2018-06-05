//
//  UIView+snap.m
//  tableViewFold
//
//  Created by eco on 2018/5/31.
//  Copyright © 2018年 eco. All rights reserved.
//

#import "UIView+snap.h"

@implementation UIView (snap)

- (UIImage *)snapImageWithFrame:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (CATransform3D)transform3DM34:(float)m34 {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = m34;
    return transform;
}

@end
