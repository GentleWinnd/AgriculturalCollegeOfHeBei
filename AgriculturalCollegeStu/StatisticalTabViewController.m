//
//  StatisticalTabViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/10.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "StatisticalTabViewController.h"
#import "StatisticalContentTableViewCell.h"
#import "ClassLogSheetViewController.h"

@interface StatisticalTabViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *statisticalTab;

@end

static NSString *cellID = @"cellID";

@implementation StatisticalTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"统计报表";
    [_statisticalTab registerNib:[UINib nibWithNibName:@"StatisticalContentTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    _statisticalTab.delegate = self;
    _statisticalTab.dataSource = self;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    StatisticalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassLogSheetViewController *classLogSheet = [[ClassLogSheetViewController alloc] init];
    classLogSheet.userRole = self.userRole;
    [self.navigationController pushViewController:classLogSheet animated:YES];
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
