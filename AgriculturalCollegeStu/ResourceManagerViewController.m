//
//  ResourceManagerViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/16.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "ResourceManagerViewController.h"
#import "SetNavigationItem.h"
#import "FeilTableViewCell.h"
#import "MCDownloadManager.h"

@interface ResourceManagerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *sourceMTableView;
@property (strong, nonatomic) IBOutlet UIView *deleteBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sourceBSpace;


@property (strong, nonatomic) NSMutableArray *deleteArray;
@property (strong, nonatomic) NSMutableArray *sourceArray;

@end
static NSString *CellID = @"CellId";

@implementation ResourceManagerViewController

#pragma mark - 设置导航栏

- (void)customNavigationBar {
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"下载列表" subTitle:@""];

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
        _deleteBtn.hidden = NO;
        _sourceBSpace.constant = 50;
        sender.titleLabel.textColor = MainThemeColor_Blue;
    } else {
        _deleteBtn.hidden = YES;
        _sourceBSpace.constant = 0;
        sender.titleLabel.textColor = MainTextColor_DarkBlack;
    }
    [_sourceMTableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationBar];
    [self initData];
    [self initTableView];
    
}

#pragma mark - init data

- (void)initData {
    self.sourceArray = [NSMutableArray arrayWithCapacity:0];
    self.deleteArray =  [NSMutableArray arrayWithCapacity:0];
    NSArray *loadedSources = [MCDownloadManager defaultInstance].allDownloadReceipts;
    if (loadedSources) {
        for (MCDownloadReceipt *recp in loadedSources) {
            if (recp.state != MCDownloadStateNone) {
                [self.sourceArray addObject:recp];
            }
        }
        [self.sourceMTableView reloadData];
    }
    
}

#pragma mark - notice action

- (void)loadNewSource:(NSNotification *)notice {
    if (notice.userInfo) {
        [self.sourceArray addObject:notice.userInfo];
        [self.sourceMTableView reloadData];
    }

}

- (void)loadSelectedSurce:(NSNotification *)notice {
    if (notice.userInfo) {
        [self.sourceArray addObjectsFromArray:[notice.userInfo allValues]];
        [self.sourceMTableView reloadData];
        
    }
}

#pragma  mark - 初始化tab

- (void)initTableView {
    
    _sourceMTableView.delegate = self;
    _sourceMTableView.dataSource = self;
    _sourceMTableView.estimatedRowHeight = 44.0;
    _sourceMTableView.rowHeight = UITableViewAutomaticDimension;
    [_sourceMTableView registerNib:[UINib nibWithNibName:@"FeilTableViewCell" bundle:nil] forCellReuseIdentifier:CellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.isDownload = YES;
    
    if (_deleteBtn.hidden) {
        cell.selectedBtn.hidden = YES;
        cell.selectedBtn.selected = NO;
        // cell.capacityTrail.hidden = YES;
        // cell.capacitylabel.hidden = NO;
        // cell.shareBtn.hidden = NO;
        //cell.downLoadBtn.hidden = NO;
        cell.leadingPace.constant = -17;
    } else {
        cell.selectedBtn.hidden = NO;
        cell.selectedBtn.selected = NO;

        // cell.capacityTrail.hidden = NO;
        // cell.capacitylabel.hidden = YES;
        //cell.downLoadBtn.hidden = YES;
        // cell.shareBtn.hidden = YES;
        cell.leadingPace.constant = 3;
    }
    cell.superViewM = self;

    id sourceInfo = self.sourceArray[indexPath.row];
    NSString *sourceName;
    NSString *sourceUrl;
    NSString *sourceSize;
    if ([sourceInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *sourceDic = sourceInfo;
        sourceName = sourceDic[@"Title"];
        sourceSize = [self caculateSourceSize:[sourceDic[@"FileSize"] integerValue]];
        sourceUrl = sourceDic[@"Url"];
        
    } else if ([sourceInfo isKindOfClass:[MCDownloadReceipt class]]){
        MCDownloadReceipt *receipt = sourceInfo;
        sourceName = receipt.url.lastPathComponent;
        sourceUrl = receipt.url;
        sourceSize = [self caculateSourceSize:(NSInteger)receipt.totalBytesWritten];
        
    }
    cell.logoImage.image = indexPath.row == 1?[UIImage imageNamed:@"word"]:[UIImage imageNamed:@"PDF"];
    cell.feilName.text = sourceName;
//    cell.capacityTrail.text = sourceSize;
    cell.url = sourceUrl;
    cell.selectedBtnType = ^(FeilBtn btnType, BOOL selected) {
        if (btnType == FeilBtnShare) {//share
            
        } else if (btnType == FeilBtnDownload) {//download
           
        
        } else {
            BOOL noContain = YES;
            for (id DSource in self.deleteArray) {
                NSString *urlStr;
                if ([DSource isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *sourceDic = DSource;
                    urlStr = sourceDic[@"Url"];
                } else {
                    MCDownloadReceipt *receipt = DSource;
                    urlStr = receipt.url;
                }
                if ([sourceUrl isEqualToString:urlStr]) {
                    break;
                    noContain = NO;
                }
            }
            if (noContain) {
                [self.deleteArray addObject:sourceInfo];
            }
        }
    };
    
    return cell;
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


- (IBAction)deleteBtnClick:(UIButton *)sender {
    
    [self.sourceArray removeObjectsInArray:self.deleteArray];
    for (id DSource in self.deleteArray) {
        NSString *urlStr;
        if ([DSource isKindOfClass:[NSDictionary class]]) {
            NSDictionary *sourceDic = DSource;
            urlStr = sourceDic[@"Url"];
        } else {
            MCDownloadReceipt *receipt = DSource;
            urlStr = receipt.url;
        }
        [[MCDownloadManager defaultInstance] removeWithURL:urlStr];
    }

    [self.sourceMTableView reloadData];
}


- (SourceType)getTheSourceType:(NSString  *)type {
    SourceType STYpe;
    
    if ([type isEqualToString:@"Vedio"]) {//all range
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
