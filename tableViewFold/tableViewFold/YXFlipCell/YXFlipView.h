//
//  YXFlipView.h
//  tableViewFold
//
//  Created by eco on 2018/6/4.
//  Copyright © 2018年 eco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+snap.h"

static float const transform34 = 1.0 / -1000;

@interface YXFlipView : UIView

@property (nonatomic, strong) YXFlipView *reverseView;  //背面

/**
 添加反面界面

 @param color 反面颜色
 @param viewHeight 反面界面高度
 */
- (void)addReverseView:(UIColor *)color viewHeight:(CGFloat)viewHeight;

/**
 添加翻转动画

 @param from 初始值
 @param to 结束值
 @param delayTime 延迟时间
 @param duration 持续时间
 @param hide 结束后是否隐藏
 */
- (void)addFlipAnimation:(float)from
                      to:(float)to
               delayTime:(NSTimeInterval)delayTime
                duration:(NSTimeInterval)duration
                    hide:(BOOL)hide;

@end
