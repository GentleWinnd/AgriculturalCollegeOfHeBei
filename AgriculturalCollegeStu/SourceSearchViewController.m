//
//  SourceSearchViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "SourceSearchViewController.h"
#import "MCDownloadManager.h"
#import "FeilTableViewCell.h"

@interface SourceSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) NSMutableArray *urls;

@end
static NSString *CellID = @"cellID";

@implementation SourceSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _urls = [NSMutableArray arrayWithCapacity:0];
    [self.inputTextFeild setDelegate:self];
    [self initTableView];
    
    
}

#pragma mark - get class source
- (void)getClassSourceWithKeyWord:(NSString *)word {
    NSDictionary *parameter = @{@"OfflineCourseId":@"a56106bc-ed87-4bf7-b368-1437428a0ccf",
                                @"Keyword":word,
                                @"ResourceType":@""};
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getClassSourcesWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1) {
            [self.urls removeAllObjects];
            [self.urls addObjectsFromArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            [_resultTableView reloadData];
        } else {
            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        [progress hiddenProgress];
        
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
    
}


#pragma  mark - 初始化tab

- (void)initTableView {
    
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.estimatedRowHeight = 44.0;
    _resultTableView.rowHeight = UITableViewAutomaticDimension;
    [_resultTableView registerNib:[UINib nibWithNibName:@"FeilTableViewCell" bundle:nil] forCellReuseIdentifier:CellID];
    
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
    FeilTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    cell.logoImage.image = indexPath.row == 1?[UIImage imageNamed:@"word"]:[UIImage imageNamed:@"PDF"];
    cell.feilName.text = self.urls[indexPath.row][@"Title"];
    cell.capacityTrail.text = [self caculateSourceSize:[self.urls[indexPath.row][@"FileSize"] integerValue]];
    cell.Stype =  [self getTheSourceType:self.urls[indexPath.row][@"ResourceType"]];

    cell.url = self.urls[indexPath.row][@"Url"];
    cell.totalSize = [self.urls[indexPath.row][@"FileSize"] longLongValue];

    cell.selectedBtnType = ^(FeilBtn btnType, BOOL selected) {
        if (btnType == FeilBtnShare) {//share
            
        } else if (btnType == FeilBtnDownload) {//download
            if (self.searchResult) {
                self.searchResult(self.urls[indexPath.row]);
            }
            [self downloadWithUrl:self.urls[indexPath.row][@"Url"]];
            [Progress progressShowcontent:[NSString stringWithFormat:@"%@已加入到下载队列",self.urls[indexPath.row][@"Title"]]];
            [self.navigationController popViewControllerAnimated:NO];
        } else {
//            [self.selectedFeilInfo setValue:self.urls[indexPath.row] forKey:[NSString stringWithFormat:@"%tu",indexPath.row]];
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



- (IBAction)btnAction:(UIButton *)sender {
    if (sender.tag == 1) {//search
        [self.inputTextFeild resignFirstResponder];
        [self getClassSourceWithKeyWord:self.inputTextFeild.text];
    } else {//cancle
        [self.navigationController  popViewControllerAnimated:NO];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {//停止编辑
    
    [self getClassSourceWithKeyWord:textField.text];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {//将要停止编辑(不是第一响应者时)

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

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
