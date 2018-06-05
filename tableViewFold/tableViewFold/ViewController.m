//
//  ViewController.m
//  tableViewFold
//
//  Created by eco on 2018/5/28.
//  Copyright © 2018年 eco. All rights reserved.
//

#import "ViewController.h"
#import "YXFlipCell.h"
#import "TestCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellHs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SWidth, SHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [UIView new];
    _tableView.estimatedRowHeight = cellCloseH;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    _cellHs = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [_cellHs addObject:[NSNumber numberWithFloat:cellCloseH]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [TestCell testCellWithTableView:tableView];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cellT = (TestCell *)cell;
    cellT.animateTimeAry = @[@0.5,@0.3];
    cellT.number = indexPath.row;
    [cellT setBGColor];
    if ([_cellHs[indexPath.row] floatValue] == cellOpenH) {
        [cellT startFoldAnimated:NO foldType:FoldTypeOpen];
    } else {
        [cellT startFoldAnimated:NO foldType:FoldTypeClose];
    }
}

//MARK: - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellHs[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isAnimating]) {
        return;
    }
    NSTimeInterval reloadTime;
    if ([_cellHs[indexPath.row] floatValue] == cellCloseH) {
        _cellHs[indexPath.row] = [NSNumber numberWithFloat:cellOpenH];
        [cell startFoldAnimated:YES foldType:FoldTypeOpen];
        reloadTime = 0.6;
    } else {
        _cellHs[indexPath.row] = [NSNumber numberWithFloat:cellCloseH];
        [cell startFoldAnimated:YES foldType:FoldTypeClose];
        reloadTime = 1.4;
    }
    [UIView animateWithDuration:reloadTime animations:^{
        [tableView beginUpdates];
        [tableView endUpdates];
    }];
    
}

@end
