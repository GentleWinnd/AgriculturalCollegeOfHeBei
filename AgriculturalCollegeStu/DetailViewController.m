//
//  DetailViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/23.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "DetailViewController.h"
#import "BaseScrollView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

#define SCROLL_TAG 778
static const NSInteger kBtnTag = 7294;

@interface DetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isDownloadViewControllerValue;

@end

@implementation DetailViewController
{
//    BOOL _isDownloadViewControllerValue;
    NSString *_Cover;
    UITableView *_tableView1;
    UITableView *_tableView2;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    UIView *_videoView;
    BaseScrollView *_scrollView;
//    HOMEButon *_buttonL;
    UIButton *_buttonL;
//    HOMEButon *_buttonR;
    UIButton *_buttonR;
    UIImageView *_btnBottomImageView;
    MPMoviePlayerController *_player;
//    当前播放第几个视频
    NSInteger _flag;
    NSMutableDictionary *_historyDic;
//    分享的图片
    NSString *_coverUrl;
//    播放图标
    UIButton *_btn;
//    标题
    UILabel *_label;
    BOOL _isFirst;
    
    UIButton *_button3;
    
    NSString *_nowPlayVideoId;
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

-(instancetype)initWithIsDownloadViewController:(BOOL)flag
{
    self = [super init];
    if (self) {
        _isDownloadViewControllerValue = flag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH /1.5f, self.navigationController.navigationBar.frame.size.height)];
    _label.text = _subTitle;
    _label.font = [UIFont systemFontOfSize:kTitleFont];
    _label.textColor = WHITE_COLOR;
    self.navigationItem.titleView = _label;

    _dataArr1 = [NSMutableArray array];
    _dataArr2 = [NSMutableArray array];
    
    if (_time.length >0) {
        _isFirst = YES;
    }
    
    [self customBackBtn];
    [self customBarButtons];
    [self customUI];
    [self requestData];
}

-(void)customBackBtn
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 20, 20);
    [button1 addTarget:self action:@selector(onBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    [button1 addTarget:self action:@selector(onShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonR1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 22, 22);
    [button2 setBackgroundImage:[UIImage imageNamed:@"favorate"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"收藏图标1"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(onFavorateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [_AFNManager GET:[NSString stringWithFormat:URL_CHECK_FAVORITE, [_userDefaults objectForKey:USERINFO][@"AccessToken"], _subId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([dic[@"State"] integerValue] ==1) {
//            button2.selected = YES;
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error.description);
//    }];
    button2.tag = kBtnTag;
    UIBarButtonItem *barButtonR2 = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
#pragma mark -开始下载
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button3.frame = CGRectMake(0, 0, 22, 22);
    [_button3 addTarget:self action:@selector(onDownloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"downcache"] forState:UIControlStateNormal];
    _button3.userInteractionEnabled = NO;
    UIBarButtonItem *barButtonR3 = [[UIBarButtonItem alloc]initWithCustomView:_button3];
    
    self.navigationItem.rightBarButtonItems = @[barButtonR1 ,barButtonR2, barButtonR3];
}

-(void)onShareBtnClick:(UIButton *)sender
{
    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:_subTitle
//                                       defaultContent:_subTitle
//                                                image:[ShareSDK imageWithUrl:_coverUrl]
//                                                title:@""
//                                                  url:@"http://www.baidu.com"
//                                          description:_subTitle
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
//
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          SHARE_TYPE_NUMBER(1),
//                          SHARE_TYPE_NUMBER(22),
//                          SHARE_TYPE_NUMBER(23),
//                          nil];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(@"%@", [error errorDescription]);
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
}

#pragma -mark 收藏按钮
-(void)onFavorateBtnClick:(UIButton *)sender
{
    ([_userDefaults objectForKey:USERINFO] ==nil) ? ({
//        UserCenterViewController *uvc = [[UserCenterViewController alloc]initWithFlag:YES];
//        __weak typeof(self) myself = self;
//        uvc.favoriteBlock = ^(){
//            myself.AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//            [myself.AFNManager GET:[NSString stringWithFormat:URL_CHECK_FAVORITE, [myself.userDefaults objectForKey:USERINFO][@"AccessToken"], myself.subId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                UIButton *btn = (UIButton *)[myself.view viewWithTag:kBtnTag];
//                if ([dic[@"State"] integerValue] ==1) {
//                    btn.selected = YES;
//                } else {
//                    NSDictionary *para = @{@"CourseId": myself.subId, @"AccessToken": [myself.userDefaults objectForKey:USERINFO][@"AccessToken"]};
//                    [myself.AFNManager POST:URL_SET_FAVORITE parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//                        if ([dic[@"FavoritesState"] integerValue] ==1) {
//                            sender.selected = YES;
//                        } else {
//                            sender.selected = NO;
//                        }
//                        
//                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        ALERT_HOME(nil, error.localizedDescription);
//                    }];
//                    NSLog(@"%@",  myself.subId);
//                    NSLog(@"%@", [myself.userDefaults objectForKey:USERINFO][@"AccessToken"]);
//                }
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                ALERT_HOME(nil, error.localizedDescription);
//            }];
//        };
//        [self.navigationController pushViewController:uvc animated:YES];
    }) : ({
        NSDictionary *para = @{
                               @"CourseId": _subId,
                               @"AccessToken": [_userDefaults objectForKey:USERINFO][@"AccessToken"]
                               };
//        [_AFNManager POST:URL_SET_FAVORITE parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            if ([dic[@"FavoritesState"] integerValue] ==1) {
//                sender.selected = YES;
//            } else {
//                sender.selected = NO;
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            ALERT_HOME(nil, error.localizedDescription);
//        }];
        NSLog(@"%@",  _subId);
        NSLog(@"%@", [_userDefaults objectForKey:USERINFO][@"AccessToken"]);
    });
}

-(void)onDownloadBtnClick:(UIButton *)sender
{
    NSLog(@"%@", [NSString stringWithFormat:@"%@", _player.contentURL]);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4", path, _dataArr2[_flag][@"Id"]];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSArray *arr = [_userDefaults objectForKey:DOWNLOAD];
        for (NSDictionary *dic in arr) {
            if ([dic[@"Id"] isEqualToString:_dataArr2[_flag][@"Id"]]) {
//                if ([dic[@"downloadFinish"] isEqualToString:@"1"]) {
//                    _HUD.mode = MBProgressHUDModeText;
//                    _HUD.labelText = @"该视频已经下载完毕";
//                    [_HUD show:YES];
//                    [_HUD hide:YES afterDelay:1];
//                } else {
//                    _HUD.mode = MBProgressHUDModeText;
//                    _HUD.labelText = @"该视频已经存在于下载队列";
//                    [_HUD show:YES];
//                    [_HUD hide:YES afterDelay:1];
//                }
                break;
            }
        }
    } else {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
//        [app downloadFileURL:[NSString stringWithFormat:@"%@", _player.contentURL] savePath:path fileName:_dataArr2[_flag][@"Id"] tag:0 withInfo:_dataArr2[_flag] andCoverUrl:_Cover andSubId:_subId andSubTitle:_subTitle];
//        _HUD.mode = MBProgressHUDModeText;
//        _HUD.labelText = @"已经开始下载";
//        [_HUD show:YES];
//        [_HUD hide:YES afterDelay:1];
    }
}

-(void)customUI
{
    [self customPlayerBgView];
    
    [self customButton];
    
    [self customScrollView];

}

- (void)initPlayerBtn {
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = _player.view.frame;
    [_btn addTarget:self action:@selector(onPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setImage:[UIImage imageNamed:@"play_icon"] forState:UIControlStateNormal];
    [_videoView addSubview:_btn];

}

#pragma mark - 播放器
-(void)customPlayerViewWithStrUrl:(NSString *)strUrl {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4", path, _dataArr2[_flag][@"Id"]];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSArray *arr = [_userDefaults objectForKey:DOWNLOAD];
        for (NSDictionary *dic in arr) {
            if ([dic[@"Id"] isEqualToString:_dataArr2[_flag][@"Id"]]) {
                if ([dic[@"downloadFinish"] isEqualToString:@"1"]) {
                    _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:fileName]];
                } else {
                    _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:strUrl]];
                }
                break;
            }
        }
    } else {
        _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:strUrl]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];

    _player.view.frame = _videoView.bounds;
    _player.controlStyle = MPMovieControlStyleEmbedded;
    if (_isFirst) {
        [_player setInitialPlaybackTime:_time.floatValue];
        _isFirst = !_isFirst;
    }
    _flag =0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    [_videoView addSubview:_player.view];
    
    
}

#pragma -mark 播放完毕回调
-(void)movieFinishedCallback:(id)sender {
    (_dataArr2.count -1 ==_flag) ? ({
//        ALERT_HOME(nil, @"所有视频播放完毕");
        [_player stop];
    }) : ({
//        _flag ++;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_flag inSection:0];
        [self tableView:_tableView2 didSelectRowAtIndexPath:indexPath];
        [_tableView2 selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    });

}

-(void)onPlayBtnClick:(UIButton *)sender {
    [_player play];
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    [_tableView2 selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionTop];
    sender.hidden = YES;
}

-(void)customPlayerBgView {
    _videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 200)];
    _videoView.backgroundColor = BLACK_COLOR;
    [self.view addSubview:_videoView];
}

-(void)customButton {
    _buttonL = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonL.frame = CGRectMake(0, _videoView.frame.origin.y +_videoView.frame.size.height , WIDTH /2.f, 40);
    [_buttonL setTitle:@"介绍" forState:UIControlStateNormal];
    [_buttonL addTarget:self action:@selector(onIntroduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _buttonL.backgroundColor = WHITE_COLOR;
    [_buttonL setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [self.view addSubview:_buttonL];

    _buttonR = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonR.frame = CGRectMake(_buttonL.frame.origin.x +_buttonL.frame.size.width, _buttonL.frame.origin.y, _buttonL.frame.size.width, _buttonL.frame.size.height);
    [_buttonR setTitle:@"章节" forState:UIControlStateNormal];
    [_buttonR addTarget:self action:@selector(onChapterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _buttonR.backgroundColor = WHITE_COLOR;
    [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    [self.view addSubview:_buttonR];
    
    _btnBottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2)];
    _btnBottomImageView.backgroundColor = RED_COLOR;
    [self.view addSubview:_btnBottomImageView];
}

-(void)onIntroduceBtnClick:(UIButton *)sender {
    [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.6f animations:^{
        _scrollView.contentOffset = CGPointMake(0, 0);
        _btnBottomImageView.frame = CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
        [_scrollView endEditing:YES];
    }];
   
}

-(void)onChapterBtnClick:(UIButton *)sender {
    [sender setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [_buttonL setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    [UIView animateWithDuration:0.6f animations:^{
        _scrollView.contentOffset = CGPointMake(WIDTH, 0);
        _btnBottomImageView.frame = CGRectMake(WIDTH /2.f, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
        [_scrollView endEditing:YES];
    }];

}

-(void)customScrollView {
    CGFloat orginY = _btnBottomImageView.frame.origin.y+_btnBottomImageView.frame.size.height;
    _scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0,orginY, WIDTH, HEIGHT-orginY+64)];
    _scrollView.backgroundColor = RGB_COLOR(243, 243, 239);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(WIDTH *2.f, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag = SCROLL_TAG +1;
    [self.view addSubview:_scrollView];
    
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, WIDTH, _scrollView.frame.size.height -1) style:UITableViewStylePlain];
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.tag = SCROLL_TAG +2;
    _tableView1.backgroundColor = WHITE_COLOR;
    _tableView1.tableFooterView = [[UIView alloc]init];
    [_scrollView addSubview:_tableView1];
    
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 1, WIDTH, _tableView1.frame.size.height -1) style:UITableViewStylePlain];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.tag = SCROLL_TAG +3;
    _tableView2.backgroundColor = WHITE_COLOR;
    _tableView2.tableFooterView = [[UIView alloc]init];
    [_scrollView addSubview:_tableView2];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag ==SCROLL_TAG +2) {
        if (section ==0) {
            return @"课程描述";
        } else if (section ==1) {
            return @"讲师介绍";
        }
    }
    return @"课程目录";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio {
    if (tableView.tag ==SCROLL_TAG +2) {
        return 30;
    } else {
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==SCROLL_TAG +2) {
        if (indexPath.section ==0) {
            HOMELabel *label = [[HOMELabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH -10, 20)];
            label.text = _dataArr1[indexPath.section];
            label.font = [UIFont systemFontOfSize:13];
            return 10 +label.frame.size.height;
        } else if (indexPath.section ==1) {
            HOMELabel *label = [[HOMELabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH -40, 20)];
            label.text = _dataArr1[indexPath.section][@"Description"];
            label.font = [UIFont systemFontOfSize:13];
            return 259 /2.f +15 +label.frame.size.height;
        }
    }
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIImageView *imagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 8)];
    imagView.backgroundColor = RGB_COLOR(243, 243, 239);
    return imagView;
}

-(void)requestData {
    __weak typeof(self) myself = self;
     MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"正在加载"];
    [NetServiceAPI getMVCCourseDetailsWithParameters:@{} success:^(id responseObject) {
        NSDictionary *dic = [NSDictionary safeDictionary:responseObject];
        _historyDic = [NSMutableDictionary dictionary];
        _coverUrl = _subCover;
        [_historyDic setObject:_subCover forKey:@"Cover"];
        if (![dic[@"Information"] isEqual:[NSNull null]]) {
            [_dataArr1 addObject:dic[@"Information"]];
        }
        for (NSDictionary *mDic in dic[@"Units"]) {
            [_dataArr2 addObject:mDic];
        }
        if (_dataArr2.count >0) {
            [myself customPlayerViewWithStrUrl:_dataArr2[0][@"Url"]];
            _nowPlayVideoId = _dataArr2[0][@"Id"];
            _button3.userInteractionEnabled = YES;
        }
        _Cover = _subCover;
        [progress hiddenProgress];
        [_tableView1 reloadData];
        [_tableView2 reloadData];

    } failure:^(NSError *error) {
        if (_isDownloadViewControllerValue) {
            NSDictionary *para = @{@"Title": _subTitle, @"Id": _videoId};
            [_dataArr2 addObject:para];
            [myself customPlayerViewWithStrUrl:nil];
            }
        [progress hiddenProgress];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == SCROLL_TAG +2) {
        return _dataArr1.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag ==SCROLL_TAG +2) {
        if (_dataArr1[0]) {
            return 1;
        } else {
            return 0;
        }
    }
    return _dataArr2.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==SCROLL_TAG +2) {
        static NSString *cellId = @"cellId0xsqwe";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = NO;
        if (indexPath.section ==0) {
            CGFloat mynum = 15;
            HOMELabel *label = [[HOMELabel alloc]initWithFrame:CGRectMake(mynum, 5, WIDTH -mynum *2, 20)];
            label.text = _dataArr1[indexPath.section];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = MainTextColor_DarkBlack;
            [cell.contentView addSubview:label];
        } else {
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 259 /2.5f, 259 /2.5f)];
            [iconImageView setImageWithURL:[NSURL URLWithString:_dataArr1[indexPath.section][@"Photo"]] placeholderImage:[UIImage imageNamed:@"default_head"]];
            iconImageView.contentMode = UIViewContentModeScaleAspectFill;
            iconImageView.layer.cornerRadius = iconImageView.frame.size.height /2.f;
            iconImageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:iconImageView];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImageView.frame.origin.x +iconImageView.frame.size.width +10, 0, WIDTH -iconImageView.frame.origin.x -iconImageView.frame.size.width -15, 20)];
            nameLabel.center = CGPointMake(nameLabel.center.x, iconImageView.center.y);
            nameLabel.text = _dataArr1[indexPath.section][@"Name"];
            [cell.contentView addSubview:nameLabel];
            
            HOMELabel *desLabel = [[HOMELabel alloc]initWithFrame:CGRectMake(20, iconImageView.frame.origin.y +iconImageView.frame.size.height +15, WIDTH -40, 20)];
            desLabel.text = _dataArr1[indexPath.section][@"Description"];
            desLabel.font = [UIFont systemFontOfSize:13];
            desLabel.textColor = MaintextColor_LightBlack;
            [cell.contentView addSubview:desLabel];
        }
        return cell;
    } else {
        static NSString *cellId = @"cellId0xqwec";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.highlightedTextColor = RED_COLOR;
        if (_flag ==indexPath.row) {
            cell.selected = YES;
        }
        cell.textLabel.text = _dataArr2[indexPath.row][@"Title"];
        cell.textLabel.textColor = MainTextColor_DarkBlack;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == SCROLL_TAG +3) {
        _flag = indexPath.row;
        [_player stop];
        _label.text = _dataArr2[indexPath.row][@"Title"];
        _player.contentURL = [NSURL URLWithString:_dataArr2[indexPath.row][@"Url"]];
        _nowPlayVideoId = _dataArr2[indexPath.row][@"Id"];
        if ([_userDefaults objectForKey:USERINFO]) {
            NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
            if ([[_userDefaults objectForKey:key] count] >0) {
                NSArray *dataArr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:key]];
                [dataArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([[obj allValues] containsObject:_dataArr2[indexPath.row][@"Id"]]) {
                        [_player setInitialPlaybackTime:[((NSDictionary *)obj)[@"Time"] floatValue]];
                    }
                }];
            }
        }
        [_player play];
        _btn.hidden = YES;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == SCROLL_TAG +1) {
        [_scrollView endEditing:YES];
        if (scrollView.contentOffset.x == 0) {
            [UIView animateWithDuration:0.f animations:^{
                [_buttonL setTitleColor:RED_COLOR forState:UIControlStateNormal];
                [_buttonR setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
                _btnBottomImageView.frame = CGRectMake(0, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
            }];
        } else {
            [UIView animateWithDuration:0.f animations:^{
                [_buttonR setTitleColor:RED_COLOR forState:UIControlStateNormal];
                [_buttonL setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
                _btnBottomImageView.frame = CGRectMake(WIDTH /2.f, _buttonL.frame.origin.y +_buttonL.frame.size.height, _buttonL.frame.size.width, 2);
            }];
        }
    }
}

- (void)moviePlayerPlaybackStateChanged:(NSNotification *)notification {
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playbackState = moviePlayer.playbackState;
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
        {
            NSLog(@"MPMoviePlaybackStateStopped");
//            if (_flag +1 <= _dataArr2.count -1) {
//                [_player stop];
//                _player.contentURL = [NSURL URLWithString:_dataArr2[_flag++][@"Url"]];
//                [_player play];
//            } else {
//                ALERT_HOME(nil, @"已是最后一个视频");
//            }
            break;
        }
            
        case MPMoviePlaybackStatePlaying:
        {
            NSLog(@"MPMoviePlaybackStatePlaying");
            break;
        }
            
        case MPMoviePlaybackStatePaused:
        {
            NSLog(@"MPMoviePlaybackStatePaused");
            break;
        }
            
        case MPMoviePlaybackStateInterrupted:
        {
            NSLog(@"MPMoviePlaybackStateInterrupted");
            break;
        }
            
        case MPMoviePlaybackStateSeekingForward:
        {
            NSLog(@"MPMoviePlaybackStateSeekingForward");
            break;
        }
            
        case MPMoviePlaybackStateSeekingBackward:
        {
            NSLog(@"MPMoviePlaybackStateSeekingBackward");
            break;
        }
            
        default:
            break;
    }
}

-(void)dealloc {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (_player && _player.currentPlaybackTime >0) {
        if ([_userDefaults objectForKey:USERINFO]) {
            NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:key]];
            [_historyDic setObject:_subId forKey:@"Id"];
            [_historyDic setObject:_subTitle forKey:@"Name"];
            [_historyDic setObject:[NSString stringWithFormat:@"%f", _player.currentPlaybackTime] forKey:@"Time"];
            [_historyDic setObject:_nowPlayVideoId forKey:@"VideoId"];
            [_historyDic setObject:[NSDate date] forKey:@"UpdateTime"];
            [_historyDic setObject:@"MVC" forKey:@"Type"];
            if (arr.count ==0) {
                [arr addObject:_historyDic];
            } else {
                for (NSInteger i=0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    if ([[dic allValues] containsObject:_nowPlayVideoId]) {
                        [arr removeObjectAtIndex:i];
                        [arr addObject:_historyDic];
//                        [arr replaceObjectAtIndex:i withObject:_historyDic];
                        break;
                    } else {
                        if (i ==arr.count -1) {
                            [arr addObject:_historyDic];
                        }
                    }
                }
            }
            [_userDefaults setObject:arr forKey:key];
            [_userDefaults synchronize];
            if (_refreshBlock) {
                _refreshBlock();
            }
        }
        [_player stop];
        _player =nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
