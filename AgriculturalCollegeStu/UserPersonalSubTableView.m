//
//  UserPersonalSubTableView.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/7.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "UserPersonalSubTableView.h"
#import "HOMEBaseViewController.h"
#import "SubDetailTableViewCell.h"
#import "DetailViewController.h"
#import "HistoryTableViewCell.h"
#import "DownloadTableViewCell.h"
#import "MyMoviePlayerViewController.h"
#import "MukeDetailViewController.h"
#import "CourseDetailTableViewCell.h"
#import "UserCenterCouseTableViewCell.h"
#import "MBProgressManager.h"
#import "User.h"


@implementation UserPersonalSubTableView {
    NSMutableArray *_dataArr;
    __block NSInteger _flag;
    NSUserDefaults *_userDefaults;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withViewController:(UIViewController *)viewController andTagNum:(NSInteger)num
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _superViewController = viewController;
//        _hud = [[HOMEMBProgressHUD alloc]initWithView:viewController.view];
//        [viewController.view addSubview:_hud];
        _flag =1;
        _dataArr = [NSMutableArray array];
        _subTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT -64 -150 -50 -40) style:UITableViewStylePlain];
        _subTableView.delegate = self;
        _subTableView.dataSource = self;
        _subTableView.tableFooterView = [UIView new];
        [self.contentView addSubview:_subTableView];
        
        [_subTableView registerNib:[UINib nibWithNibName:@"UserCenterCouseTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserCenterCouseTableViewCell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveFinishDownload) name:@"haveFinishDownload" object:nil];
        
    }
    return self;
}

-(void)setTagNum:(NSInteger)tagNum
{
    if (tagNum ==0) {
        _tagNum =2;
    } else if (tagNum ==2) {
        _tagNum = 0;
    } else {
        _tagNum = tagNum;
    }
    
    if (tagNum ==3) {

    } else {
        _subTableView.editing = NO;
    }
//    __weak typeof(self) myself = self;
//    if (_tagNum ==0) {
////        _subTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////            _flag =1;
////            [myself makeData];
////        }];
////        _subTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
////            _flag ++;
////            [myself makeData];
////        }];
//    }

    [self makeData];
}

-(void)haveFinishDownload
{
    [_dataArr removeAllObjects];
    [self makeData];
}

-(void)makeData
{
//    [_dataArr removeAllObjects];
//    NSLog(@"%zd", _tagNum);
//    if (_tagNum ==1) {
//        [_dataArr removeAllObjects];
//        MBProgressManager *progress = [[MBProgressManager alloc] init];
//        [progress showProgress];
//       
////        [manager GET:[NSString stringWithFormat:URL_FAVORITE_LIST, [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO][@"AccessToken"], _flag] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
////            [_hud hide:YES];
////            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////            if (_flag ==1) {
////                [_dataArr removeAllObjects];
////            }
////            for (NSDictionary *dict in dic[@"Items"]) {
////                UserPersonModel *model = [[UserPersonModel alloc]init];
////                [model setValuesForKeysWithDictionary:dict];
////                [_dataArr addObject:model];
////            }
////            [_subTableView reloadData];
////        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////            [_dataArr removeAllObjects];
////            [_hud hide:YES];
////        }];
//    } else if (_tagNum ==2) {
//        NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
//        NSMutableArray *array = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:key]];
//        NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
//        _dataArr = [NSMutableArray arrayWithArray:reversedArray];
//        [_subTableView reloadData];
//    } else if (_tagNum ==0) {
//        [_dataArr removeAllObjects];
////        _hud.labelText = @"正在请求";
////        [_hud show:YES];
////        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
////        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
////        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
////        [manager GET:[NSString stringWithFormat:URL_USERMUKE_LIST, [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO][@"AccessToken"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
////            [_hud hide:YES];
////            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////            if (_flag ==1) {
////                [_dataArr removeAllObjects];
////            }
////            for (NSDictionary *dict in dic[@"Courses"]) {
////                UserPersonModel *model = [[UserPersonModel alloc]init];
////                [model setValuesForKeysWithDictionary:dict];
////                [_dataArr addObject:model];
////            }
////            [_subTableView reloadData];
////        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////            [_hud hide:YES];
////        }];
////
////    } else {
////        [_dataArr removeAllObjects];
////        _dataArr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:DOWNLOAD]];
////        [_subTableView reloadData];
////    }
////    [_subTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNum ==0) {
        UserCenterCouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCouseTableViewCell"];
        User *model = _dataArr[indexPath.row];
        cell.name.text = model.userName;
        [cell.icon setImageWithURL:[NSURL URLWithString:model.avater] placeholderImage:[UIImage imageNamed:@"默认图"]];
        return cell;
    } else if (_tagNum ==1) {
        static NSString *cellId = @"cellId20xx2";
        CourseDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CourseDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        User *model = _dataArr[indexPath.row];
        cell.title.text = model.userName;
        cell.detail.text = [NSString stringWithFormat:@"%@", model.Description];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:model.avater] placeholderImage:[UIImage imageNamed:@"默认图"]];
        cell.periodLabel.text = [NSString stringWithFormat:@"集数：%@", model.period];
        return cell;
    }
    else if (_tagNum ==2) {
        static NSString *cellId = @"cellId0xx2";
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell =  [[HistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            cell.selectionStyle = NO;
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

    } else {
        static NSString *cellId = @"cellId0xx2x";
        DownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[DownloadTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
            cell.selectionStyle = NO;
            [cell setEditing:YES animated:YES];
        }
        NSDictionary *dic = _dataArr[indexPath.row];
        cell.videoInfo = dic;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNum ==1) {
        User *model = _dataArr[indexPath.row];
        if ([model.CourseType isEqualToString:@"MVC"]) {
            DetailViewController *dvc = [[DetailViewController alloc]init];
            dvc.subCover = model.avater;
            dvc.subId = model.userID;
            dvc.subTitle = model.userName;
            [_superViewController.navigationController pushViewController:dvc animated:YES];
        } else {
            MukeDetailViewController *mvc = [[MukeDetailViewController alloc]init];
            mvc.subId = model.userID;
            mvc.subTitle = model.userName;
            [_superViewController.navigationController pushViewController:mvc animated:YES];
        }
    } else if (_tagNum ==2) {
        DetailViewController *dvc = [[DetailViewController alloc]init];
        dvc.subCover = _dataArr[indexPath.row][@"Cover"];
        dvc.subId = _dataArr[indexPath.row][@"Id"];
        dvc.subTitle = _dataArr[indexPath.row][@"Name"];
        dvc.time = _dataArr[indexPath.row][@"Time"];
        [_superViewController.navigationController pushViewController:dvc animated:YES];
    } else if (_tagNum ==0) {
        User *model = _dataArr[indexPath.row];
        MukeDetailViewController *dvc = [[MukeDetailViewController alloc]init];
        dvc.subId = model.userID;
        dvc.subTitle = model.userName;
        [_superViewController.navigationController pushViewController:dvc animated:YES];
    } else {
        
        if ([_dataArr[indexPath.row][@"downloadFinish"] isEqualToString:@"1"]) {
            if ([_dataArr[indexPath.row][@"tag"] isEqualToString:@"0"]) {
                DetailViewController *dvc = [[DetailViewController alloc]initWithIsDownloadViewController:YES];
                dvc.subCover = _dataArr[indexPath.row][@"Cover"];
                dvc.subId = _dataArr[indexPath.row][@"subId"];
                dvc.subTitle = _dataArr[indexPath.row][@"subTitle"];
                dvc.videoId = _dataArr[indexPath.row][@"Id"];
                [_superViewController.navigationController pushViewController:dvc animated:YES];
            } else {
                MukeDetailViewController *dvc = [[MukeDetailViewController alloc]init];
                dvc.subId = _dataArr[indexPath.row][@"subId"];
                dvc.subTitle = _dataArr[indexPath.row][@"subTitle"];
                [_superViewController.navigationController pushViewController:dvc animated:YES];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_tagNum) {
        case 1:
            return 120;
            break;
            
        default:
            return 100;
            break;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [[_userDefaults objectForKey:DOWNLOAD] mutableCopy];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:arr[indexPath.row][@"fileName"] error:nil];
    [arr removeObjectAtIndex:indexPath.row];
    [_userDefaults removeObjectForKey:DOWNLOAD];
    [_userDefaults setObject:arr forKey:DOWNLOAD];
    [_userDefaults synchronize];
    [self makeData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tagNum ==3) {
        return YES;
    } else {
        return NO;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

