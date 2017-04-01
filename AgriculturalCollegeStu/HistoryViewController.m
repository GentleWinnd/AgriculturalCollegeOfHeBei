//
//  HistoryViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/2.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "DetailViewController.h"
#import "MukeDetailViewController.h"
//#import "UIButton+Block.h"

@interface HistoryViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HistoryViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    __block CGFloat _myHeight;
    __block NSMutableIndexSet *_indexSet;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH /3.f, self.navigationController.navigationBar.frame.size.height)];
    label.text = @"历史记录";
    label.textColor = WHITE_COLOR;
    label.font = [UIFont systemFontOfSize:kTitleFont];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    _myHeight = 0;
    _indexSet = [NSMutableIndexSet indexSet];
    
    [self customBackBtn];
    [self customBarButtons];
    [self makeData];
    [self customUI];
}

-(void)customBackBtn
{
    __weak typeof(self) myself = self;
    HOMEButon *button1 = [[HOMEButon alloc]initWithFrame:CGRectMake(0, 0, 20, 20) withTitle:@"" andButtonClickEvent:^(HOMEButon *__weak sender) {
        [myself.navigationController popViewControllerAnimated:YES];
    }];
    
//    [button1 handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
//     
//    }];
    
    [button1 setBackgroundImage:[UIImage imageNamed:@"返回按钮"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.leftBarButtonItems = @[barButtonR1];
}

-(void)onBackBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)customBarButtons
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 20, 20);
    [button1 addTarget:self action:@selector(onBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    self.navigationItem.rightBarButtonItems = @[barButtonR1];
}

-(void)onBarBtnClick:(UIButton *)sender
{
    [_tableView setEditing:!_tableView.editing animated:YES];
    if (_tableView.editing) {
        _myHeight = 40;
    } else {
        _myHeight = 0;
    }
    [_tableView reloadData];
}

-(void)makeData
{
    [_dataArr removeAllObjects];
    if ([_userDefaults objectForKey:USERINFO]) {
        NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
        if ([[_userDefaults objectForKey:key] count] >0) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:key]];
            NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
            _dataArr = [reversedArray mutableCopy];
            [_tableView reloadData];
        }
    }
}

-(void)customUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT -64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId0xx2";
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
//        cell.selectionStyle = NO;
    }
    NSString *strTime ;
    NSInteger mm = [_dataArr[indexPath.row][@"Time"] integerValue] /60;
    if (mm >9) {
        NSInteger ss = [_dataArr[indexPath.row][@"Time"] integerValue] %60;
        if (ss >9) {
            strTime = [NSString stringWithFormat:@"%zd:%zd", mm, ss];
        } else {
            strTime = [NSString stringWithFormat:@"%zd:0%zd", mm, ss];
        }
    } else {
        NSInteger ss = [_dataArr[indexPath.row][@"Time"] integerValue] %60;
        if (ss >9) {
            strTime = [NSString stringWithFormat:@"0%zd:%zd", mm, ss];
        } else {
            strTime = [NSString stringWithFormat:@"0%zd:0%zd", mm, ss];                        
        }
    }
    cell.detailLabel.text = _dataArr[indexPath.row][@"Name"];
    cell.timeLabel.text = [NSString stringWithFormat:@"观看至：%@", strTime];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"Cover"]] placeholderImage:[UIImage imageNamed:@"默认图"]];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];

    UIButton *allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelectBtn.frame = CGRectMake(10, 5, WIDTH /2.f -15, 30);
    [allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allSelectBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [allSelectBtn addTarget:self action:@selector(onAllSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allSelectBtn setBackgroundImage:[UIImage imageNamed:@"全选按钮"] forState:UIControlStateNormal];
    [bgView addSubview:allSelectBtn];
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(allSelectBtn.frame.origin.x +allSelectBtn.frame.size.width +10, allSelectBtn.frame.origin.y, allSelectBtn.frame.size.width, allSelectBtn.frame.size.height);
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(onDeletBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"登录按钮-正常"] forState:UIControlStateNormal];
    [bgView addSubview:delBtn];
    
    return bgView;
}

-(void)onAllSelectBtnClick:(UIButton *)sender
{
    if (_indexSet.count ==0) {
        for (NSInteger i =0; i<_dataArr.count; i++) {
            [_indexSet addIndex:i];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        [_indexSet removeAllIndexes];
        for (NSInteger i =0; i<_dataArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }

}

-(void)onDeletBtnClick:(UIButton *)sender
{
    [_dataArr removeObjectsAtIndexes:_indexSet];
     NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
     [_userDefaults setObject:_dataArr forKey:key];
     [_userDefaults synchronize];
     [_indexSet removeAllIndexes];
     [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _myHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [_indexSet addIndex:indexPath.row];
    } else {
        if ([_dataArr[indexPath.row][@"Type"] isEqualToString:@"MVC"]) {
            DetailViewController *dvc = [[DetailViewController alloc]init];
            dvc.subCover = _dataArr[indexPath.row][@"Cover"];
            dvc.subId = _dataArr[indexPath.row][@"Id"];
            dvc.subTitle = _dataArr[indexPath.row][@"Name"];
            dvc.time = _dataArr[indexPath.row][@"Time"];
            __weak typeof(self) myself = self;
            dvc.refreshBlock = ^(){
                [myself makeData];
            };
            [self.navigationController pushViewController:dvc animated:YES];
        } else {
            MukeDetailViewController *dvc = [[MukeDetailViewController alloc]init];
//            dvc.subCover = _dataArr[indexPath.row][@"Cover"];
            dvc.subId = _dataArr[indexPath.row][@"Id"];
            dvc.subTitle = _dataArr[indexPath.row][@"Name"];
//            dvc.time = _dataArr[indexPath.row][@"Time"];
//            __weak typeof(self) myself = self;
//            dvc.refreshBlock = ^(){
//                [myself makeData];
//            };
            [self.navigationController pushViewController:dvc animated:YES];
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView.editing) {
        [_indexSet removeIndex:indexPath.row];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
