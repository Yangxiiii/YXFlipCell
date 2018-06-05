//
//  YXFlipCell.m
//  tableViewFold
//
//  Created by eco on 2018/6/4.
//  Copyright © 2018年 eco. All rights reserved.
//

#import "YXFlipCell.h"
#import "YXFlipView.h"
#import "Masonry.h"

#define SWidth [UIScreen mainScreen].bounds.size.width

@interface YXFlipCell()
@property (nonatomic, strong) YXFlipView *forwardView;              //折叠起来的界面
@property (nonatomic, strong) UIView *containerView;                //内容界面
@property (nonatomic, strong) UIView *animateView;                  //动画界面
@property (nonatomic, strong) NSMutableArray *flipViewAry;          //翻转界面数组
@property (nonatomic, strong) NSMutableArray *flipAnimateTimeAry;   //每个翻转动作时间数组
@property (nonatomic, assign) CGFloat cornerRad;                    //圆角半径
@property (nonatomic, assign) NSInteger foldCount;                  //折叠次数
@property (nonatomic, assign) CGFloat forwardViewHeight;            //折叠之后收起界面的高度(不包括padding)
@property (nonatomic, assign) CGFloat subFlipHeight;                //折叠子界面高度 (子界面折叠高度必须小于折叠完成后的高度)
@property (nonatomic, strong) UIColor *reverseColor;                //背面界面高度
/**
 cell内容内边距约束数组 默认上下左右 10
 @[@1]          --> 上下1 左右10
 @[@1,@2]       --> 上下1 左右2
 @[@1,@2,@3]    --> 左右2 上1 下3
 @[@1,@2,@3,@4] --> 上1 右2 下3 左4
 */
@property (nonatomic, strong) NSArray *paddingAry;

@end

@implementation YXFlipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initFunc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
            forwardViewHeight:(CGFloat)forwardViewHeight
                subFlipHeight:(CGFloat)subFlipHeight
                    foldCount:(NSInteger)foldCount
                    cornerRad:(CGFloat)cornerRad
                   paddingAry:(NSArray *)paddingAry
                 reverseColor:(UIColor *)reverseColor {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _forwardViewHeight = forwardViewHeight;
        _subFlipHeight = subFlipHeight;
        _foldCount = foldCount;
        _cornerRad = cornerRad == 0 ? 0.01 : cornerRad;
        _paddingAry = paddingAry;
        _reverseColor = reverseColor;
        [self initFunc];
    }
    return self;
}

- (UIView *)viewWithIndex:(NSInteger)index {
    if (index == 0) {
        return _forwardView;
    } else {
        return [self.contentView viewWithTag:100+index];
    }
}

- (BOOL)isAnimating {
    return _animateView.alpha == 1;
}

//MARK: - set
- (void)setSubFlipHeight:(CGFloat)subFlipHeight {
    _subFlipHeight = subFlipHeight;
    __weak typeof(self) weakSelf = self;
    [_forwardView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.forwardViewHeight);
    }];
}

//MARK: - FrameCommonFunc
- (CGFloat)left {
    return self.paddingAry ? self.paddingAry.count == 1 ? 10 : (self.paddingAry.count == 2 || self.paddingAry.count == 3) ? [self.paddingAry[1] floatValue] : self.paddingAry.count == 4 ? [self.paddingAry[3] floatValue] : 10 : 10;
}
- (CGFloat)right {
    return self.paddingAry ? self.paddingAry.count == 1 ? 10 : (self.paddingAry.count == 2 || self.paddingAry.count == 3 || self.paddingAry.count == 4) ? [self.paddingAry[1] floatValue] : 10 : 10;
}
- (CGFloat)top {
    return self.paddingAry ? (self.paddingAry.count == 1 || self.paddingAry.count == 2 || self.paddingAry.count == 3 || self.paddingAry.count == 4) ? [self.paddingAry[0] floatValue] : 10 : 10;
}
- (CGFloat)bottom {
    return self.paddingAry ? (self.paddingAry.count == 1 || self.paddingAry.count == 2) ? [self.paddingAry[0] floatValue] : (self.paddingAry.count == 3 || self.paddingAry.count == 4) ? [self.paddingAry[2] floatValue] : 10 : 10;
}

//MARK: - animateCommonFunc
//获取每个翻转动作时间数组
- (void)initFlipAnimateTimeAry {
    _flipAnimateTimeAry = [NSMutableArray array];
    if (_animateTimeAry) {
        if (_animateTimeAry.count == 1) {
            for (int i = 0; i < _foldCount*2; i++) {
                [_flipAnimateTimeAry addObject:[NSNumber numberWithDouble:[_animateTimeAry[0] doubleValue]/2]];
            }
        } else if (_animateTimeAry.count == 2 || (_animateTimeAry.count >= 2 && _animateTimeAry.count != _foldCount)) {
            for (int i = 0; i < _foldCount*2; i++) {
                if (i < 2) {
                    [_flipAnimateTimeAry addObject:[NSNumber numberWithDouble:[_animateTimeAry[0] doubleValue]/2]];
                } else {
                    [_flipAnimateTimeAry addObject:[NSNumber numberWithDouble:[_animateTimeAry[1] doubleValue]/2]];
                }
            }
        } else {
            for (int i = 0; i < _foldCount; i++) {
                [_flipAnimateTimeAry addObject:[NSNumber numberWithDouble:[_animateTimeAry[i] doubleValue]/2]];
                [_flipAnimateTimeAry addObject:[NSNumber numberWithDouble:[_animateTimeAry[i] doubleValue]/2]];
            }
        }
    } else {
        for (int i = 0; i < _foldCount*2; i++) {
            [_flipAnimateTimeAry addObject:[NSNumber numberWithDouble:0.5/2]];
        }
    }
}

//移除动画子元素
- (void)removeAnimateItems {
    for (UIView *view in _animateView.subviews) {
        [view removeFromSuperview];
    }
}

//初始化翻转界面数组
- (void)initFlipViewArray {
    _flipViewAry = [NSMutableArray array];
    [_flipViewAry addObject:_forwardView];
    for (UIView *view in _animateView.subviews) {
        if ([view isKindOfClass:[YXFlipView class]]) {
            YXFlipView *tempV = (YXFlipView *)view;
            [_flipViewAry addObject:tempV];
            if (tempV.reverseView) {
                [_flipViewAry addObject:tempV.reverseView];
            }
        }
    }
}

//添加动画子元素
- (void)addAnimateItems {
    _containerView.alpha = 1;
    CGSize containerSize = _containerView.bounds.size;
    CGSize forwardSize = _forwardView.bounds.size;
    
    //第一个子界面无需折叠,直接截图就行
    UIImage *image = [_containerView snapImageWithFrame:CGRectMake(0, 0, containerSize.width, _forwardViewHeight)];
    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
    imageV.tag = 200;
    [_animateView addSubview:imageV];
    imageV.frame = CGRectMake(0, 0, containerSize.width, forwardSize.height);

    //第二个子界面 锚点为0.5 0
    UIImage *image2 = [_containerView snapImageWithFrame:CGRectMake(0, _forwardViewHeight, containerSize.width, _forwardViewHeight)];
    UIImageView *imageV2 = [[UIImageView alloc] initWithImage:image2];
    YXFlipView *flipV2 = [[YXFlipView alloc] initWithFrame:imageV2.frame];
    flipV2.layer.anchorPoint = CGPointMake(0.5, 0);
    flipV2.layer.transform = [self transform3DM34:transform34];
    flipV2.tag = 201;
    [flipV2 addSubview:imageV2];
    [_animateView addSubview:flipV2];
    flipV2.frame = CGRectMake(0, _forwardViewHeight, containerSize.width, _forwardViewHeight);

    //剩余子界面
    for (int i = 0; i < (_foldCount - 1); i++) {
        UIImage *imageT = [_containerView snapImageWithFrame:CGRectMake(0, _forwardViewHeight*2+i*_subFlipHeight, containerSize.width, _subFlipHeight)];
        UIImageView *imageVT = [[UIImageView alloc] initWithImage:imageT];
        YXFlipView *flipV = [[YXFlipView alloc] initWithFrame:imageVT.frame];
        flipV.layer.anchorPoint = CGPointMake(0.5, 0);
        flipV.layer.transform = [self transform3DM34:transform34];
        [flipV addSubview:imageVT];
        [_animateView addSubview:flipV];
        flipV.frame = CGRectMake(0, _forwardViewHeight*2+i*_subFlipHeight, containerSize.width, _subFlipHeight);
        flipV.tag = 202+i;
    }

    _containerView.alpha = 0;

    //添加背景界面
    YXFlipView *tempFlipV;
    for (UIView *view in _animateView.subviews) {
        if ([view isKindOfClass:[YXFlipView class]]) {
            if (view.tag > 201) {
                [tempFlipV addReverseView:_reverseColor viewHeight:view.frame.size.height];
            }
            tempFlipV = (YXFlipView *)view;
        }
    }
    [self initFlipViewArray];
}

//MARK: - 初始化方法
- (void)initFunc {
    
    [self addForwardView];
    [self addContainerView];
    [self addAnimateView];
    
    [self.contentView bringSubviewToFront:_forwardView];
}

//添加折叠收起的界面
- (void)addForwardView {
    _forwardView = [[YXFlipView alloc] init];
    _forwardView.layer.masksToBounds = YES;
    _forwardView.layer.cornerRadius = _cornerRad ? _cornerRad : 10;
    _forwardView.layer.anchorPoint = CGPointMake(0.5, 1);
    _forwardView.layer.transform = [self transform3DM34:transform34];
    _forwardView.tag = 100;
    [self.contentView addSubview:_forwardView];
    __weak typeof(self) weakSelf = self;
    [_forwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(weakSelf.top+weakSelf.forwardViewHeight/2);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(weakSelf.left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-weakSelf.right);
        make.height.mas_equalTo(weakSelf.forwardViewHeight);
    }];
}

//添加展开内容界面
- (void)addContainerView {
    //展开内容界面
    _containerView = [[UIView alloc] init];
    _containerView.tag = 101;
    _containerView.alpha = 0;
    [self.contentView addSubview:_containerView];
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.cornerRadius = _cornerRad ? _cornerRad : 10;
    __weak typeof(self) weakSelf = self;
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(weakSelf.top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(weakSelf.left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-weakSelf.right);
        make.height.mas_equalTo(weakSelf.forwardViewHeight*2 + weakSelf.subFlipHeight*(weakSelf.foldCount - 1));
    }];
    
    //详细界面
    CGFloat y = 0;
    CGFloat h = _forwardViewHeight;
    for (int i = 0; i < (_foldCount+1); i++) {
        UIView *subView = [[UIView alloc] init];
        subView.tag = 102+i;
        subView.frame = CGRectMake(0, y, SWidth - self.left - self.right, h);
        [_containerView addSubview:subView];
        y += (i < 2 ? _forwardViewHeight : _subFlipHeight);
        h = (i < 1 ? _forwardViewHeight : _subFlipHeight);
    }
    
}

//添加动画界面
- (void)addAnimateView {
    _animateView = [[UIView alloc] init];
    [self.contentView addSubview:_animateView];
    __weak typeof(self) weakSelf = self;
    [_animateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).offset(weakSelf.top);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(weakSelf.left);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-weakSelf.right);
        make.height.mas_equalTo(weakSelf.forwardViewHeight*2 + weakSelf.subFlipHeight*(weakSelf.foldCount - 1));
    }];
    _animateView.backgroundColor = [UIColor clearColor];
    _animateView.alpha = 0;
}

//MARK: - animate

- (void)startFoldAnimated:(BOOL)animated foldType:(FoldType)foldType {
    if (animated) {
        foldType == FoldTypeOpen ? [self openAnimated] : [self closeAnimated];
    } else {
        _forwardView.alpha = foldType == FoldTypeOpen ? 0 : 1;
        _containerView.alpha = foldType == FoldTypeOpen ? 1 : 0;
    }
}

//动画展开
- (void)openAnimated {
    [self removeAnimateItems];
    [self addAnimateItems];
    _animateView.alpha = 1;
    _containerView.alpha = 0;
    
    //隐藏翻转子元素
    for (YXFlipView *flipView in _flipViewAry) {
        if (flipView.tag && flipView.tag != 100) {
            flipView.alpha = 0;
        }
    }

    [self initFlipAnimateTimeAry];
    //添加动画效果
    NSTimeInterval delay = 0;
    float from = 0;
    float to = -M_PI_2;
    BOOL hide = YES;
    for (int i = 0; i < _flipViewAry.count; i++) {
        YXFlipView *flipView = _flipViewAry[i];
        [flipView addFlipAnimation:from to:to delayTime:delay duration:[_flipAnimateTimeAry[i] doubleValue] hide:hide];
        from = from == 0 ? M_PI_2 : 0;
        to = to == 0 ? -M_PI_2 : 0;
        hide = !hide;
        delay += [_flipAnimateTimeAry[i] doubleValue];
    }
    
    //圆角效果过渡
    UIImageView *imageV = [_animateView viewWithTag:200];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = _cornerRad;
    //在界面翻转还没到90度就已经能看到底部界面的圆角了,所以需要提前取消圆角
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([_flipAnimateTimeAry[0] doubleValue]*0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        imageV.layer.cornerRadius = 0;
    });
    //显示结果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animateView.alpha = 0;
        self.containerView.alpha = 1;
    });
    
}

//动画收起
- (void)closeAnimated {
    [self removeAnimateItems];
    [self addAnimateItems];
    _animateView.alpha = 1;
    _containerView.alpha = 0;
    
    //隐藏背面view
    for (YXFlipView *flipView in _flipViewAry) {
        if (!flipView.tag) {
            flipView.alpha = 0;
        }
    }
    
    [self initFlipAnimateTimeAry];
    //逆转时间和界面数组
    _flipAnimateTimeAry = [NSMutableArray arrayWithArray:[_flipAnimateTimeAry reverseObjectEnumerator].allObjects];
    _flipViewAry = [NSMutableArray arrayWithArray:[_flipViewAry reverseObjectEnumerator].allObjects];
    //添加动画效果
    NSTimeInterval delay = 0;
    float from = 0;
    float to = M_PI_2;
    BOOL hide = YES;
    for (int i = 0; i < _flipViewAry.count; i++) {
        YXFlipView *flipView = _flipViewAry[i];
        [flipView addFlipAnimation:from to:to delayTime:delay duration:[_flipAnimateTimeAry[i] doubleValue] hide:hide];
        from = from == 0 ? -M_PI_2 : 0;
        to = to == 0 ? M_PI_2 : 0;
        hide = !hide;
        delay += [_flipAnimateTimeAry[i] doubleValue];
    }
    //圆角效果过渡
    UIImageView *imageV = [_animateView viewWithTag:200];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay - [_flipAnimateTimeAry.lastObject doubleValue] - 0.2*[_flipAnimateTimeAry[_foldCount*2-2] doubleValue]) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        imageV.layer.cornerRadius = self.cornerRad;
    });
    //显示结果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animateView.alpha = 0;
        self.containerView.alpha = 0;
        //收起来时防止cell滑动
        [self setNeedsDisplay];
    });
    
}

@end
