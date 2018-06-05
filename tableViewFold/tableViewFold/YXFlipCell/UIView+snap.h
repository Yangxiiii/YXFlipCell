//
//  UIView+snap.h
//  tableViewFold
//
//  Created by eco on 2018/5/31.
//  Copyright © 2018年 eco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (snap)

/**
 界面截图

 @param frame 截取位置尺寸
 @return 截取的图片
 */
- (UIImage *)snapImageWithFrame:(CGRect)frame;


/**
 设置透视效果

 @param m34 z轴的值,越靠近0效果越不明显
 @return return value
 */
- (CATransform3D)transform3DM34:(float)m34;

@end
