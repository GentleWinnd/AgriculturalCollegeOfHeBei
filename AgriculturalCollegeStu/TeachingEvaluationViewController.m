//
//  TeachingEvaluationViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "TeachingEvaluationViewController.h"
#import "EvaluationInfoViewController.h"
#import "StuEvaluationViewController.h"
#import "courseNameTableViewCell.h"
#import "UserData.h"

@interface TeachingEvaluationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *allCourceTab;

@end
static NSString *cellID = @"courseNameCellID";

@implementation TeachingEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"教学评价"];
    
    [self initTableView];
    
}

- (void)initTableView {
    
    _allCourceTab.delegate = self;
    _allCourceTab.dataSource = self;
    _allCourceTab.estimatedRowHeight = 44.0;
    _allCourceTab.rowHeight = UITableViewAutomaticDimension;
    [_allCourceTab registerNib:[UINib nibWithNibName:@"courseNameTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    courseNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.userRole == UserRoleTeacher) {
        EvaluationInfoViewController *evaluationView = [[EvaluationInfoViewController alloc] init];
        [self.navigationController pushViewController:evaluationView animated:YES];
    } else {
        StuEvaluationViewController *stuView = [[StuEvaluationViewController alloc] init];
        [self.navigationController pushViewController:stuView animated:YES];
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
