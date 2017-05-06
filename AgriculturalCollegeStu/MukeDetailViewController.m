//
//  MukeDetailViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/8/28.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "MukeDetailViewController.h"
#import "BaseScrollView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"
//#import "CourseViewController.h"
#import "UserData.h"
#import "VideoLoadManager.h"
#import "NSDictionary+Extension.h"
#import "NSArray+Extension.h"
#import "SetNavigationItem.h"
#import "HOMELabel.h"


#define SCROLL_TAG 778
#define BTN_TAG 7834

@interface MukeDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@end

@implementation MukeDetailViewController
{
    NSString *_Cover;
    UITableView *_tableView1;
    UITableView *_tableView2;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    UIView *_videoView;
    BaseScrollView *_scrollView;
    UIButton *_buttonL;
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
    //    cell展开
    NSMutableArray *_mySections;
    NSString *_downLoadId;
    NSString *videoUrl;
    BOOL deletedFVCourse;
}

- (void)setNavigationBar {
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:_subTitle subTitle:@""];
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
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

- (void)back {
    if (_player && _player.currentPlaybackTime >0) {
        if ([_userDefaults objectForKey:USERINFO]) {
            NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:key]];
            [_historyDic setObject:_subId forKey:@"Id"];
            [_historyDic setObject:_subTitle forKey:@"Name"];
            [_historyDic setObject:[NSString stringWithFormat:@"%f", _player.currentPlaybackTime] forKey:@"Time"];
            
            //            NSLog(@"%f", _player.currentPlaybackTime);
            //            NSLog(@"%f", _player.playableDuration);
            
            if (arr.count ==0) {
                [arr addObject:_historyDic];
            } else {
                for (NSInteger i=0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    if ([[dic allValues] containsObject:_subId]) {
                        [arr replaceObjectAtIndex:i withObject:_historyDic];
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
        }
        [_player stop];
        _player =nil;
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    [self setNavigationBar];
    [self initData];
    [self customUI];
    [self requestData];

}

#pragma mark - initdata

- (void)initData {

    _mySections = [NSMutableArray array];
    
    _dataArr1 = [NSMutableArray array];
    _dataArr2 = [NSMutableArray array];
    deletedFVCourse = NO;
    //    if (_time.length >0) {
    _isFirst = YES;
    //    }

}

-(void)onShareBtnClick:(UIButton *)sender {
//    //构造分享内容
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
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
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

#pragma mark - get course collected state

- (void)getCourseCollectedState {

    [NetServiceAPI getCheckSourceCollectedStateWithParameters:@{@"courseId":_subId} success:^(id responseObject) {
        if ( [responseObject[@"State"] integerValue] == 1) {
            
        } else {
        
        }
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError: error inView:self.view];
    }];

}

-(void)onDownloadBtnClick:(UIButton *)sender {
    NSLog(@"%@", [NSString stringWithFormat:@"%@", _player.contentURL]);
    if (_downLoadId.length ==0) {
        [Progress progressShowcontent:@"请选择需要下载的视频"];
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
        NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4", path, _downLoadId];
        
        if ([fileManager fileExistsAtPath:fileName]) {
            NSArray *arr = [_userDefaults objectForKey:DOWNLOAD];
            for (NSDictionary *dic in arr) {
                if ([dic[@"Id"] isEqualToString:_downLoadId]) {
                    if ([dic[@"downloadFinish"] isEqualToString:@"1"]) {
                        [Progress progressShowcontent:@"该视频已经下载完毕"];
                    } else {
                        [Progress progressShowcontent:@"该视频已经存在于下载队列"];
                    }
                    break;
                }
            }
        } else {
            NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
            
            NSMutableDictionary *dict = [_dataArr2[_flag]mutableCopy];
            [dict setObject:_downLoadId forKey:@"Id"];
            [dict removeObjectForKey:@"Subjects"];
            [[VideoLoadManager shareVideoManager] downloadFileURL:[NSString stringWithFormat:@"%@", _player.contentURL]  savePath:path fileName:_downLoadId tag:1 withInfo:dict andCoverUrl:_Cover andSubId:_subId andSubTitle:_subTitle];
            [Progress progressShowcontent:@"开始下载"];
        }
    }
}

-(void)customUI {
    
    [self customPlayerBgView];
    [self customButton];
    [self customScrollView];
}

-(void)customPlayerBgView {
    _videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 222)];
    _videoView.backgroundColor = BLACK_COLOR;
    [self.view addSubview:_videoView];
    [self customPlayerView];
}

#pragma mark - 播放器

-(void)customPlayerView {
    
    _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:videoUrl]];
    _player.view.frame = _videoView.bounds;
    _player.controlStyle = MPMovieControlStyleEmbedded;
    _flag =0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    [_videoView addSubview:_player.view];
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = _player.view.frame;
    [_btn addTarget:self action:@selector(onPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btn setImage:[UIImage imageNamed:@"paly_icon"] forState:UIControlStateNormal];
    [_videoView addSubview:_btn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateDidChange) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

-(void)onPlayBtnClick:(UIButton *)sender {
    _player.contentURL = [NSURL URLWithString:videoUrl];
    [_player play];
    sender.hidden = _player.isPreparedToPlay;
  
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

-(void)requestData {
    __weak typeof(self) myself = self;
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"正在加载"];
    [NetServiceAPI getMoocInfoWithParameters:@{@"CourseId":_subId} success:^(id responseObject) {
        _historyDic = [NSMutableDictionary dictionary];
        _coverUrl = responseObject[@"Cover"];
        [_historyDic setObject:responseObject[@"Cover"] forKey:@"Cover"];
        if (![responseObject[@"Information"] isEqual:[NSNull null]]) {
            [_dataArr1 addObject:responseObject[@"Information"]];
        }
        _Cover = responseObject[@"Cover"];
        [_tableView1 reloadData];
        if ([responseObject[@"Batchs"] count] >0) {
            if (responseObject[@"Batchs"][0][@"CourseVersionId"]) {
                [self getMOOCCourseVersion];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该课程已过期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
    }];
}

#pragma mark - get first show video

- (void)getFirstVideoSourseURL:(NSString *)url {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp4", path, _downLoadId];
    if ([fileManager fileExistsAtPath:fileName]) {
        NSArray *arr = [_userDefaults objectForKey:DOWNLOAD];
        for (NSDictionary *dic in arr) {
            if ([dic[@"Id"] isEqualToString:_downLoadId]) {
                if ([dic[@"downloadFinish"] isEqualToString:@"1"]) {
                    videoUrl = fileName;
                } else {
                    videoUrl = url;
                }
                break;
            }
        }
    } else {
        videoUrl = url;
    }
}

#pragma mark - getMOOCCourse Version

- (void)getMOOCCourseVersion {
    //@"ProtoType@b27ee2f7-dd4f-45db-bfec-573552ad8363"
    @WeakObj(self);
    [NetServiceAPI getMOOCCourseVersionDetailsWithParameters:@{@"CourseId":_CourseVersionId} success:^(id responseObject) {
        
        NSArray *datas =  [NSArray safeArray:[NSDictionary safeDictionary:responseObject][@"Groups"]];
        [_dataArr2 addObjectsFromArray:datas];
        
        if (_dataArr2.count >0) {
            if ([_dataArr2[0][@"Subjects"] count] >0) {
                [selfWeak getFirstVideoSourseURL:_dataArr2[0][@"Subjects"][0][@"Units"][0][@"Content"]];
            }
            NSInteger tempNum =0;
            for (NSDictionary *subDict in _dataArr2) {
                if ([subDict[@"Subjects"] count] >0) {
                    tempNum ++;
                    break;
                }
            }
            if (tempNum ==0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该课程无章节内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该课程无章节内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [_tableView2 reloadData];
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //[self.navigationController popViewControllerAnimated:YES];
}


-(void)customScrollView {
    CGFloat orginY = _btnBottomImageView.frame.origin.y+_btnBottomImageView.frame.size.height;

    _scrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, orginY, WIDTH, HEIGHT-orginY-64)];
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
    
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 1, WIDTH, _tableView1.frame.size.height -1) style:UITableViewStyleGrouped];
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.tag = SCROLL_TAG +3;
    _tableView2.backgroundColor = WHITE_COLOR;
    _tableView2.tableFooterView = [[UIView alloc]init];
    [_scrollView addSubview:_tableView2];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView.tag ==SCROLL_TAG +3) {
        return 1 /MAXFLOAT;
    }        return 1 /MAXFLOAT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag != SCROLL_TAG +2) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = LIGHTGRAY_COLOR.CGColor;
        button.layer.borderWidth = 0.5;
        button.tag = section +BTN_TAG;
        NSInteger myint = 10;
        [button addTarget:self action:@selector(onHeaderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, WIDTH, 44);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(myint, myint, WIDTH -myint *2, 44 -2 *myint)];
        
        NSDictionary *contentDic = [NSDictionary safeDictionary:_dataArr2[section]];
        label.text = [NSString safeString:contentDic[@"Name"]];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = MainTextColor_DarkBlack;
        [button addSubview:label];
        
        return button;
    } else {
        NSString *text;
        if (section ==0) {
            text = @"课程描述";
        } else if (section ==1) {
            text = @"讲师介绍";
        }
        UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        HeaderLabel.backgroundColor = [UIColor whiteColor];
        HeaderLabel.textColor = MainTextColor_DarkBlack;
        HeaderLabel.font = [UIFont systemFontOfSize:17];
        HeaderLabel.text = text;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 30, WIDTH, 1)];
        line.backgroundColor = RulesLineColor_LightGray;
        [HeaderLabel addSubview:line];
        return HeaderLabel;
    }
}

-(void)onHeaderBtnClick:(UIButton *)sender {
    NSLog(@"%zd", sender.tag);
    if ([_mySections containsObject:[NSNumber numberWithInteger:sender.tag -BTN_TAG]]) {
        [_mySections removeObject:[NSNumber numberWithInteger:sender.tag -BTN_TAG]];
    } else {
        [_mySections addObject:[NSNumber numberWithInteger:sender.tag -BTN_TAG]];
    }
    NSDictionary *contentDic = [NSDictionary safeDictionary:_dataArr2[sender.tag-BTN_TAG]];
    NSArray *objArr = [NSArray safeArray:contentDic[@"Subjects"]];
    if (objArr.count == 0) {
        [Progress progressShowcontent:@"此课程无详情" currView:self.view];
    } else {
        [_tableView2 reloadData];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag ==SCROLL_TAG +2) {
        return 30;
    } else {
        return 44;
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == SCROLL_TAG +2) {
        return _dataArr1.count;
    }
    return  _dataArr2.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag ==SCROLL_TAG +2) {
        if (_dataArr1[0]) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if ([_mySections containsObject:[NSNumber numberWithInteger:section]]) {
            NSArray *subObjArr = [NSArray safeArray:[NSDictionary safeDictionary:_dataArr2[section]][@"Subjects"]];
            return subObjArr.count;
        } return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==SCROLL_TAG +2) {
        static NSString *cellId = @"cellId0xsqwe";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section ==0) {
            HOMELabel *label = [[HOMELabel alloc]initWithFrame:CGRectMake(5, 5, WIDTH -10, 20)];
            label.text = _dataArr1[indexPath.section];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = MaintextColor_LightBlack;
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
            nameLabel.textColor = MainTextColor_DarkBlack;
            [cell.contentView addSubview:nameLabel];
            
            HOMELabel *desLabel = [[HOMELabel alloc]initWithFrame:CGRectMake(20, iconImageView.frame.origin.y +iconImageView.frame.size.height +15, WIDTH -40, 20)];
            desLabel.text = _dataArr1[indexPath.section][@"Description"];
            desLabel.font = [UIFont systemFontOfSize:14];
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
        
        NSArray *subObjArr = [NSArray safeArray:[NSDictionary safeDictionary:_dataArr2[indexPath.section]][@"Subjects"]];
        NSDictionary *contentDic = [NSDictionary safeDictionary:subObjArr[indexPath.row]];
        
        cell.textLabel.text = [NSString safeString:contentDic[@"Name"]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = MainTextColor_DarkBlack;
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag ==SCROLL_TAG +3) {
        [_player stop];
        _flag = indexPath.row;
        NSInteger num = 0;
        BOOL flag = NO;
        for (NSDictionary *dic in _dataArr2) {
            for (NSDictionary *dict in dic[@"Subjects"]) {
                if (num ==indexPath.section) {
                    _label.text = dict[@"Units"][indexPath.row][@"Title"];
                    if ([dict[@"Units"][indexPath.row][@"ContentType"] isEqualToString:@"Video"]) {
                        _player.contentURL = [NSURL URLWithString:dict[@"Units"][indexPath.row][@"Content"]];
                        _downLoadId = dict[@"Units"][indexPath.row][@"Id"];
                        [_player play];
                    } else {
                        [Progress progressShowcontent:@"非视频资源，不能播放"];
                    }
                    
                    flag = YES;
                    break;
                }
                num ++;
            }
            if (flag) {
                break;
            }
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
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
                        if (_flag +1 <= _dataArr2.count -1) {
                            [_player stop];
                            _player.contentURL = [NSURL URLWithString:_dataArr2[_flag++][@"Url"]];
                            [_player play];
//                            _btn.hidden = _player.isPreparedToPlay;
//                            if (_player.isPreparedToPlay == NO) {
//                                [Progress progressShowcontent:@"非视频资源，不能播放"];
//                            }

                            
                        } else {
                            ALERT_HOME(nil, @"已是最后一个视频");
                        }
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

-(void)dealloc
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (_player && _player.currentPlaybackTime >0) {
        if ([_userDefaults objectForKey:USERINFO]) {
            NSString *key = [_userDefaults objectForKey:USERINFO][@"UserName"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[_userDefaults objectForKey:key]];
            [_historyDic setObject:_subId forKey:@"Id"];
            [_historyDic setObject:_subTitle forKey:@"Name"];
            [_historyDic setObject:[NSString stringWithFormat:@"%f", _player.currentPlaybackTime] forKey:@"Time"];
            [_historyDic setObject:@"ACS" forKey:@"Type"];
            if (arr.count ==0) {
                [arr addObject:_historyDic];
            } else {
                for (NSInteger i=0; i<arr.count; i++) {
                    NSDictionary *dic = arr[i];
                    if ([[dic allValues] containsObject:_subId]) {
                        [arr replaceObjectAtIndex:i withObject:_historyDic];
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
        }
        [_player stop];
        _player =nil;
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (deletedFVCourse) {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"DeletedFVCourse" object:nil userInfo:@{@"courseID":_subId}]; 
    }
    
}

/**
 *  视频播放状态改变
 */
- (void)moviePlayerLoadStateDidChange {
    switch (_player.loadState){
        case MPMovieLoadStatePlayable:{
            /** 可播放 */;
            NSLog(@"可以播放");
            _btn.hidden = YES;
        }
            break;
        case MPMovieLoadStatePlaythroughOK:{
            /** 状态为缓冲几乎完成，可以连续播放 */;
            NSLog(@"状态为缓冲几乎完成，可以连续播放");
            _btn.hidden = YES;

        }
            break;
        case MPMovieLoadStateStalled:{
            /** 缓冲中 */
            NSLog(@"缓冲中");
            _btn.hidden = YES;

        }
            break;
        case MPMovieLoadStateUnknown:{
            /** 未知状态 */
            _btn.hidden = NO;
            [Progress progressShowcontent:@"非视频资源，不能播放"];
            [_player pause];

        }
            break;
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
