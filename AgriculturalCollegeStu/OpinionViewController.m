//
//  OpinionViewController.m
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "OpinionViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "OpinionTableViewCell.h"
#import "OpinionOtherTableViewCell.h"
#import "OpinionCommitTableViewCell.h"
#import "SetNavigationItem.h"

@interface OpinionViewController ()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    TPKeyboardAvoidingTableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITextView *myTextView;
@property (nonatomic, strong) NSMutableDictionary *para;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

static const CGFloat kTableViewHeadViewHeight = 100.f;

@implementation OpinionViewController

- (void)setNavigationBar {
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"意见反馈" subTitle:@""];;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_COLOR(243, 243, 239);
    [self setNavigationBar];
    [self initData];
    [self customUI];

}

- (void)initData {
    _para = [NSMutableDictionary dictionary];
    [self requestData];

}


-(void)requestData {
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"正在请求数据..."];

    [NetServiceAPI getAPPRecuperationWithParameters:nil success:^(id responseObject) {
        NSLog(@"%@", _dataDic);
        [progress hiddenProgress];
        _dataDic = [NSDictionary dictionaryWithDictionary:[NSDictionary safeDictionary:responseObject]];
        //        FeedbackId
        [_para setObject:_dataDic[@"Id"] forKey:@"FeedbackId"];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}

-(void)customUI {
    _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 44;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"OpinionTableViewCell" bundle:nil] forCellReuseIdentifier:@"OpinionTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OpinionOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"OpinionOtherTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OpinionCommitTableViewCell" bundle:nil] forCellReuseIdentifier:@"OpinionCommitTableViewCell"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, kTableViewHeadViewHeight)];
    CGFloat margin = 20.f;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, margin, WIDTH -2 *margin, 30)];
    titleLabel.text = @"农业大学测试版问题反馈";
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.textColor = MainTextColor_DarkBlack;
    [bgView addSubview:titleLabel];
    
    UILabel *descripLabel = [[UILabel alloc]initWithFrame:CGRectMake(margin, titleLabel.frame.origin.y +titleLabel.frame.size.height +margin, WIDTH -margin *2, 21)];
    descripLabel.text = _dataDic[@"Description"];
    descripLabel.font = [UIFont systemFontOfSize:17];
    descripLabel.textColor = MainTextColor_DarkBlack;
    [bgView addSubview:descripLabel];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeadViewHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataDic) {
        return [_dataDic[@"Config"][@"Items"] count] +2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_dataDic[@"Config"][@"Items"] count]){
        OpinionOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpinionOtherTableViewCell"];
        _myTextView = cell.opinionTextView;
        cell.opinionTextView.delegate = self;
        cell.selectionStyle = NO;
        return cell;
    } else if (indexPath.row == [_dataDic[@"Config"][@"Items"] count] +1){
//        提交按钮
        OpinionCommitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpinionCommitTableViewCell"];
        cell.target = self;
        cell.action = @selector(onCommitBtnClick);
        cell.selectionStyle = NO;
        return cell;
    }
    
    OpinionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpinionTableViewCell"];
    cell.selectionStyle = NO;
    [_dataArr addObject:cell.selectBtn];
    __weak typeof(self) myself = self;
    cell.btnClickBlock = ^(UIButton *sender) {
        NSLog(@"%@", myself.dataDic[@"Config"][@"Items"][indexPath.row][@"Title"]);
        for (UIButton *btn in myself.dataArr) {
            btn.selected = NO;
        }
        if ([[myself.dataDic[@"Config"][@"Items"][indexPath.row][@"Expand"] stringValue] isEqualToString:@"1"]) {
            myself.myTextView.userInteractionEnabled = YES;
        } else {
            myself.myTextView.userInteractionEnabled = NO;
        }
        sender.selected = !sender.selected;
        [myself.para setObject:myself.dataDic[@"Config"][@"Items"][indexPath.row][@"Key"] forKey:@"OptionKey"];
    };
    cell.reasonLabel.text = _dataDic[@"Config"][@"Items"][indexPath.row][@"Title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
//    OpinionTableViewCell *cell = (OpinionTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    cell.selectBtn.selected = YES;
//    NSLog(@"%@", cell.reasonLabel.text);
//    [tableView reloadData];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.userInteractionEnabled) {
        [_para setObject:textView.text forKey:@"Content"];
    }
}

-(void)onCommitBtnClick {
    
    [_myTextView resignFirstResponder];
    if ([_para[@"Content"] length] ==0 && _myTextView.userInteractionEnabled) {
        ALERT_HOME(nil, @"意见不能为空！");
    } else {
        MBProgressManager *progress = [[MBProgressManager alloc] init];
        [progress loadingWithTitleProgress:@"正在提交反馈……"];
        [NetServiceAPI postSubmitOptionsWithParameters:nil success:^(id responseObject) {
            [progress hiddenProgress];

            if ([responseObject[@"Message"] isEqualToString:@"ok"]) {
                [Progress progressShowcontent:@"提交成功"];
                
            } else {
                [Progress progressShowcontent:@"提交失败了"];
            }

        } failure:^(NSError *error) {
            [progress hiddenProgress];

            [KTMErrorHint showNetError:error inView:self.view];
        }];
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
