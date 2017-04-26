//
//  ClassVideoViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "ClassVideoViewController.h"
#import "CourseInfoTableViewController.h"
#import "HaventSignUpViewController.h"
#import "ClassVTableViewCell.h"
#import "ClassVHeaderView.h"
#import "FirstPageContentModel.h"
#import "MoreCourseViewController.h"
#import "MainViewCycModel.h"

@interface ClassVideoViewController ()<UITableViewDataSource, UITableViewDelegate, ClassVTableViewCellDelegate>
{
    NSMutableArray *allContentArray;
    NSMutableArray *CAContentList;
}
@property (strong, nonatomic) NSMutableArray *focuslist;
@property (strong, nonatomic) IBOutlet UITableView *classVideoTab;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end
static NSString *cellID = @"videoCellID";
@implementation ClassVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    //[self getCategoryCourse];
    [self costomView];
    [self initTableView];
    [self getCategoryCourseInfo];
    [self getMOOCSCCourseVideo];
}

- (void)costomView {
    self.indicator.layer.cornerRadius = 6;

}


#pragma mark - initData

- (void)initData {
    allContentArray = [NSMutableArray arrayWithCapacity:0];
    CAContentList = [NSMutableArray arrayWithCapacity:0];
    _focuslist = [NSMutableArray arrayWithCapacity:0];
}

- (void)getMOOCSCCourseVideo {
    NSDictionary *parageter = @{@"count":@"10"};
    [NetServiceAPI getMOOCSCourseWithParameters:parageter success:^(id responseObject) {
        for (NSDictionary *dic in responseObject) {
            
            FirstPageContentModel *model = [[FirstPageContentModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [allContentArray addObject:model];
            
//            MainViewCycModel *cycModel = [[MainViewCycModel alloc]init];
//            
//            int randomInd = (arc4random() % model.Courses.count) + 1;
//            if(randomInd == 50) randomInd = 49;
//            cycModel.Id = model.Courses[randomInd][@"Id"];
//            cycModel.Cover = model.Courses[randomInd][@"Cover"];
//            cycModel.Summary = model.Courses[randomInd][@"Description"];
//            cycModel.Title = model.Courses[randomInd][@"Name"];
//            [_focuslist addObject:cycModel];
        }
        [_indicator stopAnimating];
        [self.view bringSubviewToFront:_classVideoTab];
        [_classVideoTab reloadData];

        
    } failure:^(NSError *error) {
        
        [KTMErrorHint showNetError:error inView:self.view];
        [_indicator stopAnimating];
        [self.view bringSubviewToFront:_classVideoTab];
        
        NSLog(@"%@", error.description);

    }];


}

- (void)getCategoryCourse {
    [_indicator startAnimating];
    NSDictionary *parameter = @{@"Count":@"50"};
    [NetServiceAPI getCourseListWithParameters:parameter success:^(id responseObject) {
       // NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        for (NSDictionary *dic in responseObject) {
            
            FirstPageContentModel *model = [[FirstPageContentModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [allContentArray addObject:model];
            
            MainViewCycModel *cycModel = [[MainViewCycModel alloc]init];
            
            //int randomInd = (arc4random() % model.Courses.count) + 1;
           // if(randomInd == 50) randomInd = 49;
//            cycModel.Id = model.Courses[randomInd][@"Id"];
//            cycModel.Cover = model.Courses[randomInd][@"Cover"];
//            cycModel.Summary = model.Courses[randomInd][@"Description"];
//            cycModel.Title = model.Courses[randomInd][@"Name"];
//            [_focuslist addObject:cycModel];
        }
        [_indicator stopAnimating];
        [self.view bringSubviewToFront:_classVideoTab];
        [_classVideoTab reloadData];
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        [_indicator stopAnimating];
        [self.view bringSubviewToFront:_classVideoTab];

        NSLog(@"%@", error.description);
    }];
}

- (void)getCategoryCourseInfo {
    NSDictionary *parameter = @{@"Count":@"0"};
    [NetServiceAPI getCourseListWithParameters:parameter success:^(id responseObject) {
        
        for (NSDictionary *dic in responseObject) {
            FirstPageContentModel *model = [[FirstPageContentModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [CAContentList addObject:model];
        }

    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        NSLog(@"%@", error.description);

    }];

}

#pragma mark - initTableview

- (void)initTableView {
    
    _classVideoTab.delegate = self;
    _classVideoTab.dataSource = self;
    _classVideoTab.estimatedRowHeight = 44.0;
    _classVideoTab.rowHeight = UITableViewAutomaticDimension;
    _classVideoTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_classVideoTab registerNib:[UINib nibWithNibName:@"ClassVTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return allContentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ClassVHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"ClassVHeaderView" owner:nil options:nil].lastObject;
    FirstPageContentModel *model = allContentArray[section];
    headerView.titleLabel.text = model.Name;
    headerView.selectedBtn = ^(UIButton *selectedBtn){
//        CourseInfoTableViewController *infoView = [[CourseInfoTableViewController alloc] init];
//        infoView.categroyId = ((FirstPageContentModel *)CAContentList[section]).Id;
//        infoView.courseName = ((FirstPageContentModel *)CAContentList[section]).Name;
//
//        [self.navigationController pushViewController:infoView animated:YES];
//        [Progress progressShowcontent:@"暂无数据"];
        MoreCourseViewController *moreView = [[MoreCourseViewController alloc] init];
        moreView.allCourseArray = model.Courses;
        moreView.courseType = model.Name;
        [TabbarManager setTabBarHidden:YES];

        [self.navigationController pushViewController:moreView animated:YES];
    };
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.randomValue = 40;
    cell.myParentViewController = self;
    cell.entity = allContentArray[indexPath.section];
    cell.delegate = self;
    
    return cell;
}

- (void)ClassVTableViewCellPushSuperView:(HaventSignUpViewController *)VC animation:(BOOL)animated {
//    [self pushViewController:VC animated:animated hiddenTabbar:YES];
   // VC.parentVc = self;
    [TabbarManager setTabBarHidden:YES];

    [self.navigationController pushViewController:VC animated:animated];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TabbarManager setTabBarHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - push viewcontroller

- (void)pushViewController:(UIViewController *)VC animated:(BOOL)animated hiddenTabbar:(BOOL)hidden {
    [self.navigationController pushViewController:VC animated:YES];
    [TabbarManager setTabBarHidden:hidden];
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
