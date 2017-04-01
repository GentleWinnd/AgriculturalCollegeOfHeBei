//
//  UserPersonalCenterViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "UserPersonalCenterViewController.h"
#import "SettingViewController.h"
#import "MyInfoViewController.h"
#import "CategoryTableViewCell.h"
#import "UserPersonalSubTableView.h"
#import "UserPersonCategoryTableViewCell.h"

#define TABLEVIEW_TAG 8891

@interface UserPersonalCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation UserPersonalCenterViewController
{
    __block UILabel *_label;
    __block UILabel *_mailLabel;
    NSArray *_categoryArr;
    UITableView *_categoryTableView;
    UITableView *_tableViewSuperTableView;
    UIImageView *_iconImageView;
}

-(void)viewWillAppear:(BOOL)animated
{
//    [_categoryTableView reloadData];
//    [_tableViewSuperTableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_categoryTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH /3.f, self.navigationController.navigationBar.frame.size.height)];
    label.text = @"个人中心";
    label.textColor = WHITE_COLOR;
    label.font = [UIFont systemFontOfSize:kTitleFont];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    [self customBackBtn];
    [self customBarButtons];
    [self customUI];
    [self requestUserInfo];
    [self requestAllCategory];
}

-(void)requestAllCategory
{
    _categoryArr = [NSArray arrayWithObjects:@"历史",  @"收藏", @"慕课", @"离线", nil];
    [_categoryTableView reloadData];
    [_tableViewSuperTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_categoryTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void)customBackBtn
{
    HOMEButon *button1 = [[HOMEButon alloc]initWithFrame:CGRectMake(0, 0, 20, 20) withTitle:@"" andButtonClickEvent:^(HOMEButon *sender) {

    }];
    [button1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    self.navigationItem.leftBarButtonItems = @[barButtonR1];
}

-(void)customBarButtons
{
    __weak typeof(self) myself = self;
    HOMEButon *button1 = [[HOMEButon alloc]initWithFrame:CGRectMake(0, 0, 20, 20) withTitle:@"" andButtonClickEvent:^(HOMEButon *sender) {
        SettingViewController *svc = [[SettingViewController alloc]init];
        [myself.navigationController pushViewController:svc animated:YES];
    }];
    [button1 setBackgroundImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    self.navigationItem.rightBarButtonItems = @[barButtonR1];
}

-(void)customUI
{
    __weak typeof(self) myself = self;
    HOMEButon *topBtn = [[HOMEButon alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 150) withTitle:@"" andButtonClickEvent:^(HOMEButon *sender) {
        MyInfoViewController *mvc = [[MyInfoViewController alloc]init];
        mvc.backBlock = ^(){
            [myself requestUserInfo];
        };
        [myself.navigationController pushViewController:mvc animated:YES];
        
    }];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"person_back"] forState:UIControlStateNormal];
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 70, 70)];
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width /2.f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.image = [UIImage imageNamed:@"default_head"];
    [topBtn addSubview:_iconImageView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.frame.origin.x +_iconImageView.frame.size.width +15, _iconImageView.frame.origin.y +5, WIDTH -_iconImageView.frame.origin.x -_iconImageView.frame.size.width -20, 20)];
    _label.textColor = WHITE_COLOR;
    [topBtn addSubview:_label];
    
    _mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_label.frame.origin.x, _label.frame.origin.y +_label.frame.size.height +10, _label.frame.size.width, _label.frame.size.height)];
    _mailLabel.textColor = _label.textColor;
    [topBtn addSubview:_mailLabel];
    
    UIImageView *rightArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH -50, 30, 30, 30)];
    rightArrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    rightArrowImageView.center = CGPointMake(rightArrowImageView.center.x, _iconImageView.center.y);
    [topBtn addSubview:rightArrowImageView];
    
    [self.view addSubview:topBtn];
    
    _categoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, topBtn.frame.origin.y +topBtn.frame.size.height, 30, WIDTH) style:UITableViewStylePlain];
    _categoryTableView.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
    _categoryTableView.frame = CGRectMake(0, topBtn.frame.origin.y +topBtn.frame.size.height, WIDTH, 40);
    _categoryTableView.delegate = self;
    _categoryTableView.dataSource = self;
    _categoryTableView.separatorStyle = NO;
    _categoryTableView.showsVerticalScrollIndicator = NO;
    _categoryTableView.tag = TABLEVIEW_TAG +1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_categoryTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:_categoryTableView];
    
    _tableViewSuperTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT -64 -30) style:UITableViewStylePlain];
    _tableViewSuperTableView.transform = CGAffineTransformMakeRotation(-M_PI /2.f);
    _tableViewSuperTableView.frame = CGRectMake(0, topBtn.frame.origin.y +topBtn.frame.size.height +40, WIDTH, HEIGHT -topBtn.frame.origin.y -topBtn.frame.size.height -40);
    _tableViewSuperTableView.delegate = self;
    _tableViewSuperTableView.dataSource = self;
    _tableViewSuperTableView.separatorStyle = NO;
    _tableViewSuperTableView.showsVerticalScrollIndicator = NO;
    _tableViewSuperTableView.pagingEnabled = YES;
    _tableViewSuperTableView.tag = TABLEVIEW_TAG +2;
    _tableViewSuperTableView.scrollEnabled = NO;
    [self.view addSubview:_tableViewSuperTableView];
}

-(void)requestUserInfo
{
//    _HUD.labelText = @"正在获取个人资料";
//    [_HUD show:YES];
//    NSDictionary *dic = [_userDefaults objectForKey:USERINFO];
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [_AFNManager GET:[NSString stringWithFormat:URL_USER_INFO, dic[@"AccessToken"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [_HUD hide:YES];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if (dic[@"Avatar"] != [NSNull null]) {
//            [_iconImageView setImageWithURL:[NSURL URLWithString:dic[@"Avatar"]] placeholderImage:[UIImage imageNamed:@"default_head"]];
//        }
//        _label.text = dic[@"FullName"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [_HUD hide:YES];
//        NSLog(@"%@", error.description);
//    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag ==TABLEVIEW_TAG +1) {
        return _categoryArr.count;
    } else if (tableView.tag ==TABLEVIEW_TAG +2){
        return _categoryArr.count;
    }
    return _categoryArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==TABLEVIEW_TAG +1) {
        static NSString *cellId = @"cellId0xdwfw";
        UserPersonCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UserPersonCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI /2.f);
            cell.myTitleLabel.highlightedTextColor = RED_COLOR;
            cell.myTitleLabel.textColor = LIGHTGRAY_COLOR;
        }
        cell.myTitleLabel.text = _categoryArr[indexPath.row];

        return cell;
    } else if (tableView.tag ==TABLEVIEW_TAG +2) {
        static NSString *cellId = @"cellId0xdwfw1";
        UserPersonalSubTableView *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UserPersonalSubTableView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId withViewController:self andTagNum:indexPath.row];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI /2.f);
        }
        cell.tagNum = indexPath.row;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==TABLEVIEW_TAG +1) {
        return WIDTH/ 4.f;
    } else if (tableView.tag ==TABLEVIEW_TAG +2) {
        return WIDTH;
    }
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag ==TABLEVIEW_TAG +1) {
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [_tableViewSuperTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag ==TABLEVIEW_TAG +2) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollView.contentOffset.y /WIDTH inSection:0];
        [_categoryTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_categoryTableView didSelectRowAtIndexPath:indexPath];
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
