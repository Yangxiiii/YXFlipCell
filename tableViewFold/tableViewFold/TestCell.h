//
//  TestCell.h
//  tableViewFold
//
//  Created by eco on 2018/6/5.
//  Copyright © 2018年 eco. All rights reserved.
//

#import "YXFlipCell.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

static CGFloat cellCloseH = 180; //cell折叠之后的高度
static CGFloat cellOpenH = 440;  //cell展开后的高度
static NSInteger foldNum = 3;    //折叠次数

@interface TestCell : YXFlipCell

@property (nonatomic, assign) NSInteger number;

+ (TestCell *)testCellWithTableView:(UITableView *)tableView;
- (void)setBGColor;

@end
