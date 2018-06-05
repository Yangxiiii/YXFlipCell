//
//  YXFlipCell.h
//  tableViewFold
//
//  Created by eco on 2018/6/4.
//  Copyright © 2018年 eco. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FoldTypeOpen,
    FoldTypeClose,
} FoldType;

@interface YXFlipCell : UITableViewCell

/**
 动画时间数组
 不传默认是每个动画 0.5s
 @[@1] --> 所有翻页都是1秒
 @[@1,@2] --> 第一个翻页是1秒,之后的都是2秒
 @[@1,@2,@3] --> 如果数组个数和翻页数相同,按顺序取,否则只取前两个
 */
@property (nonatomic, strong) NSArray *animateTimeAry;

/**
 根据顺序获取cell中的界面
 一一一一一一一一一一一一一一
 | 折叠起来的界面0 |
 一一一一一一一一一一一一一一
 | | 展开后第一个2  | 1 |
 | 一一一一一一一一一一   |
 | | 展开后第二个3  |   |
 | 一一一一一一一一一一   |
 | |  ...         |   |
 | 一一一一一一一一一一一一
 @param index 顺序
 @return result
 */
- (UIView *)viewWithIndex:(NSInteger)index;

/**
 折叠或者展开

 @param animated 是否需要动画
 @param foldType 展开状态
 */
- (void)startFoldAnimated:(BOOL)animated foldType:(FoldType)foldType;

/**
 初始化方法

 @param style style
 @param reuseIdentifier reuseIdentifier
 @param forwardViewHeight 折叠之后收起界面的高度(不包括padding)
 @param subFlipHeight 折叠子界面高度
 @param foldCount 折叠次数
 @param cornerRad 圆角半径
 @param paddingAry 默认值为10
 @param reverseColor 反面界面颜色
 @return return value
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
            forwardViewHeight:(CGFloat)forwardViewHeight
                subFlipHeight:(CGFloat)subFlipHeight
                    foldCount:(NSInteger)foldCount
                    cornerRad:(CGFloat)cornerRad
                   paddingAry:(NSArray *)paddingAry
                 reverseColor:(UIColor *)reverseColor;

//当前是否正在动画
- (BOOL)isAnimating;

@end
