//
//  SourceLoadViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SourceLoadViewController.h"
#import "FeilTableViewCell.h"
#import "SetNavigationItem.h"
#import "MCDownloadManager.h"
#import "CurrentClassView.h"
#import "RecentCourseManager.h"
#import "SourceSearchViewController.h"
#import "ClassScheduleViewController.h"

@interface SourceLoadViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *FeilClassify;

@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITableView *feilTable;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *subDownLoad;
@property (strong, nonatomic) IBOutlet UIButton *subShareBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *filetabBottomSpace;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIView *rangeView;
@property (strong, nonatomic) IBOutlet UIButton *RAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *RVedioBtn;
@property (strong, nonatomic) IBOutlet UIButton *RVImageBtn;
@property (strong, nonatomic) IBOutlet UIButton *RFileBtn;
@property (strong, nonatomic) IBOutlet UIButton *RFlashBtn;
@property (strong, nonatomic) IBOutlet UIButton *ROtherBtn;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *topCourseView;

@property (assign, nonatomic) SourceType SType;
@property (copy, nonatomic) NSString *currentSourceType;
@property (strong, nonatomic) NSMutableDictionary *selectedFeilInfo;
@property (strong, nonatomic) NSMutableArray *urls;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;
@end

static NSString  *cellID = @"feilCellID";

@implementation SourceLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资源下载";

    [self customNavigationBar];
    [self initData];
    [self initTableView];
    [self customCurrentClassView];
}

#pragma mark - initdata

- (void)initData {
    self.sourceArray = [NSMutableArray arrayWithObjects:@"图像处理之数字化.PDF",@"线性代数笔记.word",@"图像高斯模糊算法.PDF",@"数字图形合成复习要点.PDF",@"高等数学复习要点.PDF",@"数字图像模拟.PDF",@"图文处理.PDF", nil];
    self.currentSourceType = @"";
    self.selectedFeilInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    self.SType = SourceTypeAll;
    self.courseId = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemCourseId];
    self.courseName = [RecentCourseManager getRecentCourseDataWithDateItem:DataItemDependentName];
    [self getClassSourceWithSourceType:_currentSourceType];
}

#pragma mark - 定义classView

- (void)customCurrentClassView {
    CurrentClassView *classView = [CurrentClassView initViewLayout];
    CGRect frame = _topCourseView.frame;
    frame.origin = CGPointMake(0, 0);
    classView.frame = frame;
    classView.courceName.text = self.courseName;
    [_topCourseView addSubview:classView];
    
    @WeakObj(classView);
    classView.selectedClick = ^(UIButton *sender) {
        ClassScheduleViewController *scheduleView = [[ClassScheduleViewController alloc] init];
        scheduleView.theSelectedClass = ^(NSDictionary *classCourse){
            self.courseName = classCourse[COURSE_RECENTACTICE_DEPENDENT][COURSE_RECENTACTICE_DEPENDENT_NAME];
            self.courseId = [NSString safeString:classCourse[COURSE_RECENTACTICE_ID]];
            classViewWeak.courceName.text = self.courseName;
            [self getClassSourceWithSourceType:_currentSourceType];
        };
        [self.navigationController pushViewController:scheduleView animated:YES];
        
    };
}

#pragma mark - get class source
- (void)getClassSourceWithSourceType:(NSString *)source {
    _currentSourceType = source;
    NSDictionary *parameter = @{@"OfflineCourseId":@"a56106bc-ed87-4bf7-b368-1437428a0ccf",
                                @"Keyword":@"",
                                @"ResourceType":source};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getClassSourcesWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            [self.urls removeAllObjects];
            [self.urls addObjectsFromArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            [_feilTable reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
        
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}

- (NSMutableArray *)urls {
    if (!_urls) {
        self.urls = [NSMutableArray array];
    }
    return _urls;
}


#pragma mark - 设置导航栏

- (void)customNavigationBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 50);
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:MainTextColor_DarkBlack forState:UIControlStateNormal];
    [button addTarget:self action:@selector(compileBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [[SetNavigationItem shareSetNavManager] setNavRightItem:self withCustomView:button];
}

#pragma Mark - 编辑按钮的点击事件

- (void)compileBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        _subView.hidden = NO;
        _filetabBottomSpace.constant = 50;
        sender.titleLabel.textColor = MainThemeColor_Blue;
    } else {
        _subView.hidden = YES;
        _filetabBottomSpace.constant = 0;
        sender.titleLabel.textColor = MainTextColor_DarkBlack;
       
    }
    [_feilTable reloadData];
}

#pragma  mark - 初始化tab

- (void)initTableView {
    
    _feilTable.delegate = self;
    _feilTable.dataSource = self;
    _feilTable.estimatedRowHeight = 44.0;
    _feilTable.rowHeight = UITableViewAutomaticDimension;
    [_feilTable registerNib:[UINib nibWithNibName:@"FeilTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urls.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (_subView.hidden) {
        cell.selectedBtn.hidden = YES;
       // cell.capacityTrail.hidden = YES;
       // cell.capacitylabel.hidden = NO;
       // cell.shareBtn.hidden = NO;
       //cell.downLoadBtn.hidden = NO;
        cell.leadingPace.constant = -17;
    } else {
        cell.selectedBtn.hidden = NO;
       // cell.capacityTrail.hidden = NO;
       // cell.capacitylabel.hidden = YES;
       //cell.downLoadBtn.hidden = YES;
       // cell.shareBtn.hidden = YES;
        cell.leadingPace.constant = 3;
    }
    
    cell.logoImage.image = indexPath.row == 1?[UIImage imageNamed:@"word"]:[UIImage imageNamed:@"PDF"];
    cell.feilName.text = self.urls[indexPath.row][@"Title"];
    cell.capacityTrail.text = [self caculateSourceSize:[self.urls[indexPath.row][@"FileSize"] integerValue]];
    cell.totalSize = [self.urls[indexPath.row][@"FileSize"] longLongValue];
    cell.Stype =  [self getTheSourceType:self.urls[indexPath.row][@"ResourceType"]];

    cell.url = self.urls[indexPath.row][@"Url"];
    cell.selectedBtnType = ^(FeilBtn btnType, BOOL selected) {
        if (btnType == FeilBtnShare) {//share
            
        } else if (btnType == FeilBtnDownload) {//download
//             NSArray *loadedSources = [MCDownloadManager defaultInstance].allDownloadReceipts;
//            for (MCDownloadReceipt *receipt in loadedSources) {
//                
//            }
            [self downloadWithUrl:self.urls[indexPath.row][@"Url"]];
            [Progress progressShowcontent:[NSString stringWithFormat:@"%@已加入到下载队列",self.urls[indexPath.row][@"Title"]]];
        } else {
            [self.selectedFeilInfo setValue:self.urls[indexPath.row] forKey:[NSString stringWithFormat:@"%tu",indexPath.row]];
        }
    };
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [[MCDownloadManager defaultInstance] removeWithURL:self.urls[indexPath.row]];
//
//        [self.urls removeObjectAtIndex:indexPath.row];
//
//        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}
//
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    //设置删除按钮
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
//        
//        [[MCDownloadManager defaultInstance] removeWithURL:self.urls[indexPath.row]];
//        [self.urls removeObjectAtIndex:indexPath.row];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//        
//    }];
//    return @[deleteRowAction];
//}

- (IBAction)topBtnAction:(UIButton *)sender {
    if (sender.tag == 1) {//排序
        [UIView animateWithDuration:0.02 animations:^{
            self.rangeView.hidden = NO;
            self.rangeView.alpha = 1;
            CGRect frame = self.rangeView.frame;
            frame.size = CGSizeMake(80, 200);
            self.rangeView.frame = frame;
            self.backView.hidden = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
            [self.backView addGestureRecognizer:tap];
            
        }];
        switch (self.SType) {
            case SourceTypeAll: {
                self.RAllBtn.selected = YES;
            }
                break;
            case SourceTypeVedio: {
                self.RVedioBtn.selected = YES;
            }
                break;
            case SourceTypeImage: {
                self.RVImageBtn.selected = YES;
            }
                break;
            case SourceTypeFile: {
                self.RFileBtn.selected = YES;
            }
                break;
            case SourceTypeFlash: {
                self.RFlashBtn.selected = YES;
            }
                break;
            case SourceTypeOther: {
                self.ROtherBtn.selected = YES;
            }
                break;
 
            default:
                break;
        }
    
    } else {//搜索
        SourceSearchViewController *searchView = [[SourceSearchViewController alloc] init];
        [self.navigationController pushViewController:searchView animated:NO];
    }
}

- (void)tapAction {
    [self rangeBtnAction:self.FeilClassify];

}

#pragma mark - caculate source size

- (NSString *)caculateSourceSize:(NSInteger)size {
    NSString *sizeStr;
    if (size<1024) {//Bty
        sizeStr = [NSString stringWithFormat:@"%tu B",size];
    } else if (size <pow(1024,2)) {//KB
        sizeStr = [NSString stringWithFormat:@"%.2f K",size/1024.00];
    } else if (size <pow(1024, 3)) {//MB
        sizeStr = [NSString stringWithFormat:@"%.2f M",size/pow(1024.00, 2)];
    } else if (size <pow(1024, 4)) {//GB
        sizeStr = [NSString stringWithFormat:@"%.2f G",size/pow(1024.00, 3)];
    }
    return sizeStr;
}

- (IBAction)rangeBtnAction:(UIButton *)sender {
    if (self.SType>10 && self.SType<17) {
        UIButton *btn = [self.view viewWithTag:self.SType];
        btn.selected = NO;
    }
    
    
    if (sender.tag == 11) {//all range
        self.SType = SourceTypeAll;
        [self getClassSourceWithSourceType:@""];
    } else if (sender.tag == 12){//vedio range
        self.SType = SourceTypeVedio;
        [self getClassSourceWithSourceType:@"Video"];
    } else if (sender.tag == 13){//image range
        self.SType = SourceTypeImage;
        [self getClassSourceWithSourceType:@"Image"];
    } else if (sender.tag == 14){//file range
        self.SType = SourceTypeFile;
        [self getClassSourceWithSourceType:@"Document"];
    } else if (sender.tag == 15){//flash range
        self.SType = SourceTypeFlash;
        [self getClassSourceWithSourceType:@"Flash"];
    } else if (sender.tag == 16){//other range
        self.SType = SourceTypeOther;
        [self getClassSourceWithSourceType:@"Other"];
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        self.rangeView.alpha = 0;
        CGRect frame = self.rangeView.frame;
        frame.size = CGSizeMake(0, 0);
        self.rangeView.frame = frame;
    }];
    self.rangeView.hidden = YES;
    self.backView.hidden = YES;
  
}

- (SourceType)getTheSourceType:(NSString  *)type {
    SourceType STYpe;
    
    if ([type isEqualToString:@"Video"]) {//all range
        STYpe = SourceTypeVedio;
    } else if ([type isEqualToString:@"Image"]){//vedio range
        STYpe = SourceTypeImage;
    } else if ([type isEqualToString:@"Document"]){//image range
        STYpe = SourceTypeFile;
    } else if ([type isEqualToString:@"Flash"]){//file range
        STYpe = SourceTypeFlash;
    } else if ([type isEqualToString:@"Other"]){//flash range
        STYpe = SourceTypeOther;
    }
    
    return STYpe;
}



- (IBAction)bottomBtnAction:(UIButton *)sender {
    if (sender.tag == 111) {//下载
        for (NSDictionary *sourceInfo in [self.selectedFeilInfo allValues]) {
            [self downloadWithUrl:sourceInfo[@"Url"]];
        }
        [Progress progressShowcontent:[NSString stringWithFormat:@"任务已添加到下载队列"]];
        [self.selectedFeilInfo removeAllObjects];
        _subView.hidden = YES;
        _filetabBottomSpace.constant = 0;
        sender.titleLabel.textColor = MainTextColor_DarkBlack;
        [_feilTable reloadData];
    } else {//分享
    
    
    }

}

#pragma mark - load source

- (void)downloadWithUrl:(NSString *)url {
    [[MCDownloadManager defaultInstance] downloadFileWithURL:url
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        
                                                        if ([receipt.url isEqualToString:url]) {
                                                            //                                                            [self.loadProgress updateProgressWithNumber:downloadProgress.fractionCompleted];
                                                            
                                                        }
                                                            
                                                        }
                                                    destination:nil
                                                    success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                        //                                                         [self.downLoadBtn setTitle:@"完成" forState:UIControlStateNormal];
                                                                                                             }
                                                    failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                        //                                                         [self.downLoadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
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
