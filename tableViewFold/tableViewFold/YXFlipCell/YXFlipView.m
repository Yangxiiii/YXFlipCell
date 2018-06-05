//
//  YXFlipView.m
//  tableViewFold
//
//  Created by eco on 2018/6/4.
//  Copyright © 2018年 eco. All rights reserved.
//

#import "YXFlipView.h"

@interface YXFlipView()<CAAnimationDelegate>
@property (nonatomic, assign) BOOL hideAfterComplete;
@end

@implementation YXFlipView

/**
 添加反面界面
 
 @param color 反面颜色
 @param viewHeight 反面界面高度
 */
- (void)addReverseView:(UIColor *)color viewHeight:(CGFloat)viewHeight {
    _reverseView = [[YXFlipView alloc] init];
    _reverseView.layer.anchorPoint = CGPointMake(0.5, 1);
    _reverseView.layer.transform = [self transform3DM34:transform34];
    _reverseView.backgroundColor = color;
    [self addSubview:_reverseView];
    _reverseView.frame = CGRectMake(0, self.bounds.size.height - viewHeight, self.bounds.size.width, viewHeight);
}

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
                    hide:(BOOL)hide {
    _hideAfterComplete = hide;
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animate.delegate = self;
    animate.fromValue = [NSNumber numberWithFloat:from];
    animate.toValue = [NSNumber numberWithFloat:to];
    animate.duration = duration;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animate.beginTime = CACurrentMediaTime() + delayTime;
    //动画结束之后保持效果
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animate forKey:@"animate1"];
}

//MARK: - CAAnimationDelegate
/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim {
    self.alpha = 1;
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_hideAfterComplete) {
        self.alpha = 0;
    }
}


@end
