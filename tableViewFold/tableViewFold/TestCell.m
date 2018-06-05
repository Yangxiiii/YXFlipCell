//
//  TestCell.m
//  tableViewFold
//
//  Created by eco on 2018/6/5.
//  Copyright © 2018年 eco. All rights reserved.
//

#import "TestCell.h"
#import "Masonry.h"

@interface TestCell()
@property (nonatomic, strong) UILabel *label;
@end

@implementation TestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (TestCell *)testCellWithTableView:(UITableView *)tableView {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
    if (cell == nil) {
        CGFloat subHeight;
        if (foldNum == 1) {
            subHeight = 0;
        } else {
            subHeight = (cellOpenH - 20 - (cellCloseH - 20)*2)/(foldNum - 1);
        }
        cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:@"TestCell"
                             forwardViewHeight:cellCloseH - 20
                                 subFlipHeight:subHeight
                                     foldCount:foldNum
                                     cornerRad:10
                                    paddingAry:@[@10,@30]
                                  reverseColor:[UIColor lightGrayColor]];
    }
    return cell;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        UIView *view = [self viewWithIndex:0];
        [view addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_top).offset(10);
            make.left.equalTo(view.mas_left).offset(10);
            make.right.equalTo(view.mas_right).offset(-10);
            make.bottom.equalTo(view.mas_bottom).offset(-10);
        }];
    }
    _label.text = [NSString stringWithFormat:@"%ld",number];
}

- (void)setBGColor {
    UIView *view0 = [self viewWithIndex:0];
    view0.backgroundColor = [UIColor orangeColor];
    for (int i = 0; i < foldNum+1; i++) {
        UIView *view = [self viewWithIndex:i+2];
        view.backgroundColor = [UIColor brownColor];
    }
}

@end
