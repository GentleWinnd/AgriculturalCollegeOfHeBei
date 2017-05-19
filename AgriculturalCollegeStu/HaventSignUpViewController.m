//
//  HaventSignUpViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/27.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HaventSignUpViewController.h"
#import "HaventSignUpTableViewCell.h"
#import "HaventSignUpOneTableViewCell.h"
#import "HaventSignUpThirdTableViewCell.h"
#import "HaventSignInForthTableViewCell.h"
#import "HaventSignUpFifthTableViewCell.h"
#import "HavenSignUpSixthTableViewCell.h"
//#import "DetailViewController.h"
//#import "MukeDetailViewController.h"
#import "SetNavigationItem.h"
#import "NSString+Extension.h"
#import "UserData.h"

@interface HaventSignUpViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HaventSignUpViewController
{
    UITableView *_tableView;
    NSDictionary *_dataDic;
    BOOL deletedFVCourse;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self getSignState:_subId];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    if (deletedFVCourse) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedFVCourse" object:nil userInfo:@{@"courseID":_subId}];
    }
    

    self.navigationController.tabBarController.tabBar.hidden = NO;
}

#pragma mark - setNavigationBar

- (void)setNavigationBar {
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"课程详情" subTitle:@""];
    //    //分享
    //    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button1.frame = CGRectMake(0, 0, 20, 20);
    //    [button1 addTarget:self action:@selector(onShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [button1 setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    //    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    //收藏
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 22, 22);
    [button2 setBackgroundImage:[UIImage imageNamed:@"love_no.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"loved"] forState:UIControlStateSelected];
    button2.tag = 111;
    [button2 addTarget:self action:@selector(onFavorateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonR2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
    //    //下载按钮
    //    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button3.frame = CGRectMake(0, 0, 22, 22);
    //    [button3 addTarget:self action:@selector(onDownloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [button3 setBackgroundImage:[UIImage imageNamed:@"update"] forState:UIControlStateNormal];
    //    UIBarButtonItem *barButtonR3 = [[UIBarButtonItem alloc]initWithCustomView:button3];
    self.navigationItem.rightBarButtonItems = @[barButtonR2];
    [self setFavotateBtnState];
}

#pragma mark - set btn state

- (void)setFavotateBtnState {
    
    NSDictionary *parameter = @{@"courseId":_subId};
    [NetServiceAPI getCheckSourceCollectedStateWithParameters:parameter success:^(id responseObject) {
        
        UIButton *btn = [self.navigationController.navigationBar  viewWithTag:111];
        if ([responseObject[@"State"] integerValue] == 1) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
            //[Progress progressShowcontent:responseObject[@"Message"]];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}
#pragma mark - set favorate btn state

-(void)onFavorateBtnClick:(UIButton *)sender {
    NSDictionary *para = @{@"CourseId": _subId,
                           @"AccessToken": [UserData getAccessToken]};
    
    [NetServiceAPI postCollectionFavoriteWithParameters:para success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] ==1) {
            sender.selected = !sender.selected;
            [Progress progressShowcontent: sender.selected == NO ?@"取消收藏":@"收藏成功"];
            deletedFVCourse = !sender.selected;
        }
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError: error inView:self.view];
    }];
    
    //    NSLog(@"%@",  _subId);
    //    NSLog(@"%@", [_userDefaults objectForKey:USERINFO][@"AccessToken"]);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self requestData];
}


#pragma mark - get course Info
-(void)requestData {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"正在加载中..."];
    NSDictionary *parameter = @{@"ID":self.subId};
    [NetServiceAPI getMoocInfoWithParameters:parameter success:^(id responseObject) {
        _dataDic = [NSDictionary dictionaryWithDictionary:responseObject];
        [self customUI];
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

#pragma mark - custom UI

-(void)customUI {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT -64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 50.f;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HaventSignUpOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"HaventSignUpOneTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HaventSignUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"HaventSignUpTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HaventSignUpThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"HaventSignUpThirdTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HaventSignInForthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HaventSignInForthTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HaventSignUpFifthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HaventSignUpFifthTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"HavenSignUpSixthTableViewCell" bundle:nil] forCellReuseIdentifier:@"HavenSignUpSixthTableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        HaventSignUpOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HaventSignUpOneTableViewCell"];
        if (_dataDic[@"Cover"] != [NSNull null]) {
            [cell.iconImage setImageWithURL:[NSURL URLWithString:_dataDic[@"Cover"]] placeholderImage:[UIImage imageNamed:@"placehodlerimg"]];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row ==1) {
        HaventSignUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HaventSignUpTableViewCell"];
        cell.subCourseArr = _dataDic[@"Batchs"];
        cell.subTitle = _subTitle;
        cell.subId = _subId;
        cell.courseVersionId = [[NSArray safeArray:_dataDic[@"Batchs"]] firstObject][@"CourseVersionId"];
        cell.superViewController = self;
        cell.name.text = _dataDic[@"Name"];
        if (_hasSignUp) {
            [cell.signUpBtn setTitle:@"立即观看" forState:UIControlStateNormal];
//            cell.signUpBtn.backgroundColor = RGB_COLOR(131, 176, 17);
        }
        
        if ([_dataDic[@"Batchs"] count] >0) {
            if ((BOOL)_dataDic[@"Batchs"][0][@"RegistrationAtAnyTime"] == YES) {
                NSTimeInterval startTimeInterval = [[NSDate date] timeIntervalSinceDate:[[_dataDic[@"Batchs"][0][@"StartDate"] componentsSeparatedByString:@"T"] componentsJoinedByString:@" "].HOMETransformToDate];
                NSTimeInterval allTimeInterval = [[[_dataDic[@"Batchs"][0][@"EndDate"] componentsSeparatedByString:@"T"] componentsJoinedByString:@" "].HOMETransformToDate timeIntervalSinceDate:[[_dataDic[@"Batchs"][0][@"StartDate"] componentsSeparatedByString:@"T"] componentsJoinedByString:@" "].HOMETransformToDate];
                cell.nowTimeLabel.text = [NSString stringWithFormat:@"进行至第%.f周，共%.f周", ceilf(startTimeInterval /60 /60 /24 /7), ceilf(allTimeInterval /60 /60 /24 /7)];
                cell.courseAllTimeLabel.text = [NSString stringWithFormat:@"开课时间：%@ 至 %@",[_dataDic[@"Batchs"][0][@"StartDate"] componentsSeparatedByString:@"T"][0], [_dataDic[@"Batchs"][0][@"EndDate"] componentsSeparatedByString:@"T"][0]];
            } else {
                cell.nowTimeLabel.text = @"未开始";
                cell.courseAllTimeLabel.text = @"筹备中";
                cell.signUpBtn.hidden = YES;
            }
        } else {
            cell.nowTimeLabel.text = @"未开始";
            cell.courseAllTimeLabel.text = @"筹备中";
            cell.signUpBtn.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row ==2) {
        HaventSignUpThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HaventSignUpThirdTableViewCell"];
        if (_dataDic[@"Information"] != [NSNull null]) {
            NSString *text = [[NSString safeString:_dataDic[@"Information"]] stringByReplacingOccurrencesOfString:@"*" withString:@" "];
            cell.descriptionLabel.text = text;
            cell.descriptionLabel.textColor = MaintextColor_LightBlack;
            cell.descriptionLabel.font = [UIFont systemFontOfSize:14];
        } else {
            cell.descriptionLabel.text = @" ";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row ==3) {
        HaventSignInForthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HaventSignInForthTableViewCell"];
        if ([_dataDic[@"Batchs"] count] >0) {
            if (_dataDic[@"Batchs"][0][@"Teachers"][0][@"Photo"] != [NSNull null]) {
                [cell.iconImageView setImageWithURL:[NSURL URLWithString:_dataDic[@"Batchs"][0][@"Teachers"][0][@"Photo"]] placeholderImage:[UIImage imageNamed:@"placehodlerimg"]];
            }
            if (_dataDic[@"Batchs"][0][@"Teachers"][0][@"FullName"] != [NSNull null]) {
                cell.nameLabel.text = _dataDic[@"Batchs"][0][@"Teachers"][0][@"FullName"];
            } else {
                cell.nameLabel.text = @" ";
            }
            if (_dataDic[@"Batchs"][0][@"Teachers"][0][@"Description"] != [NSNull null]) {
                cell.desLabel.text = _dataDic[@"Batchs"][0][@"Teachers"][0][@"Description"];
            } else {
                cell.desLabel.text = @" ";
            }

        } else {
            cell.nameLabel.text = @" ";
            cell.desLabel.text = @" ";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row ==4) {
//        HavenSignUpSixthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HavenSignUpSixthTableViewCell"];
         HaventSignInForthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HaventSignInForthTableViewCell"];
        if (_dataDic[@"Organization"] != [NSNull null]) {
            if (_dataDic[@"Organization"][@"Logo"] != [NSNull null]) {
                [cell.iconImageView setImageWithURL:[NSURL URLWithString:_dataDic[@"Organization"][@"Logo"]] placeholderImage:[UIImage imageNamed:@"placehodlerimg"]];
            }
            if (_dataDic[@"Organization"][@"Name"] != [NSNull null]) {
                cell.nameLabel.text = _dataDic[@"Organization"][@"Name"];
            } else {
                cell.nameLabel.text = @" ";
            }
            cell.desLabel.text = [NSString safeString:_dataDic[@"Organization"][@"Description"]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        HaventSignUpFifthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HaventSignUpFifthTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma  mark - 获取是否签到

- (void)getSignState:(NSString *)courseId {

    [NetServiceAPI getStudentSignStateWithParameters:@{@"Id":courseId} success:^(id responseObject) {
        if ([responseObject[@"State"] intValue] == 1) {
            self.hasSignUp = YES;
        } else {
            self.hasSignUp = NO;
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
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
