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
#import "NoDataView.h"

@interface SourceSearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) NoDataView *noView;


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

#pragma mark - add no data view

- (void)createNodataView:(NoDataType)type {
    _noView = [NoDataView layoutNoDataView];
    _noView.type = NoDataTypeDefualt;
    _noView.frame = self.resultTableView.frame;
    @WeakObj(self)
    _noView.reloadData = ^(){
        [selfWeak getClassSourceWithKeyWord:_inputTextFeild.text];
    };
    
    [self.view addSubview:_noView];
}


#pragma mark - get class source
- (void)getClassSourceWithKeyWord:(NSString *)word {
    NSDictionary *parameter = @{@"OfflineCourseId":_courseId,
                                @"Keyword":word,
                                @"ResourceType":@""};
    [_noView removeNoDataView];
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getClassSourcesWithParameters:parameter success:^(id responseObject) {
        [progress hiddenProgress];

        if ([responseObject[@"State"] integerValue] == 1) {
            [self.urls removeAllObjects];
            [self.urls addObjectsFromArray:[NSArray safeArray:responseObject[@"DataObject"]]];
            
            if (self.urls.count == 0) {
                [self createNodataView:NoDataTypeDefualt];
            } else {
                [_resultTableView reloadData];
            }
        } else {
            [self createNodataView:NoDataTypeLoadFailed];

            [Progress progressShowcontent:responseObject[@"Message"]];
        }
        
    } failure:^(NSError *error) {
        [self createNodataView:NoDataTypeLoadFailed];
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
    
    cell.feilName.text = self.urls[indexPath.row][@"Title"];
    cell.capacityTrail.text = [self caculateSourceSize:[self.urls[indexPath.row][@"FileSize"] integerValue]];
    cell.Stype =  [self getTheSourceType:self.urls[indexPath.row][@"ResourceType"]];
    cell.SType =  [NSString safeString:self.urls[indexPath.row][@"ResourceType"]];

    cell.totalSize = [self.urls[indexPath.row][@"FileSize"] longLongValue];

    cell.capacitylabel.hidden = YES;
    cell.downLoadBtn.hidden = YES;
    
    cell.selectedBtnType = ^(FeilBtn btnType, BOOL selected) {
        if (btnType == FeilBtnShare) {//share
            
        } else if (btnType == FeilBtnDownload) {//download
//            if (self.searchResult) {
//                self.searchResult(self.urls[indexPath.row]);
//            }
           
        } else {
//            [self.selectedFeilInfo setValue:self.urls[indexPath.row] forKey:[NSString stringWithFormat:@"%tu",indexPath.row]];
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sourceInfo = [NSDictionary safeDictionary:self.urls[indexPath.row]];
    
    BOOL loaded = NO;
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:[NSString safeString:sourceInfo[@"Url"]]];
 
    if (receipt.state == MCDownloadStateNone || receipt.state == MCDownloadStateFailed) {
        if (self.searchResult) {
            self.searchResult(sourceInfo);
            [Progress progressShowcontent:[NSString stringWithFormat:@"%@已加入到下载队列",self.urls[indexPath.row][@"Title"]]];
        }
    } else {
        [Progress progressShowcontent:[NSString stringWithFormat:@"%@已在下载队列",self.urls[indexPath.row][@"Title"]]];
    }
    self.navigationController.navigationBarHidden = NO;
  
    [self.navigationController popViewControllerAnimated:NO];

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
        if (_inputTextFeild.text.length == 0) {
            return;
        }
        [self getClassSourceWithKeyWord:self.inputTextFeild.text];
    } else {//cancle
        self.navigationController.navigationBarHidden = NO;

        [self.navigationController  popViewControllerAnimated:NO];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {//停止编辑
    if (textField.text.length == 0) {
        return;
    }
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
