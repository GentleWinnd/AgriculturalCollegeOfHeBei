//
//  FavoriteViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/13.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "HaventSignUpViewController.h"
#import "SetNavigationItem.h"
#import "KTMRefreshFooter.h"


@interface FavoriteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *Favoritetable;
@property (strong, nonatomic) NSMutableArray *favoriteCourses;
@property (assign, nonatomic) NSInteger PageCount;
@property (assign, nonatomic) NSInteger currentPage;
@end
static NSString *cellID = @"CellID";
@implementation FavoriteViewController

- (void)setNavigationBar {
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"收藏" subTitle:@""];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    [self initData];
    [self initFavoriteTable];
    [self getfavoriteCourse];
}

- (void)initData {
    _currentPage = 0;
    _PageCount = 0;
    self.favoriteCourses = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletedFVCourse:) name:@"DeletedFVCourse" object:nil];

}

- (void)deletedFVCourse:(NSNotification *)notice {
    NSDictionary *DCourseInfo = notice.userInfo;
    if (DCourseInfo.count>0) {
        for (NSDictionary *courseInfo in self.favoriteCourses) {
            if ([courseInfo[@"Id"] isEqualToString:[DCourseInfo allValues].firstObject]) {
                [self.favoriteCourses removeObject:courseInfo];
                [self.Favoritetable reloadData];
                break;
            }
        }
    }
}

#pragma mark - get favorite course

- (void)getfavoriteCourse {
    
    MBProgressManager *progress = [[MBProgressManager alloc] init];
    [progress loadingWithTitleProgress:@"加载中..."];
    [NetServiceAPI getFavoriteSourcesWithParameters:@{@"page":[NSNumber numberWithInteger:_currentPage]} success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue] == 1)  {
            [self.favoriteCourses removeAllObjects];
            [self.favoriteCourses addObjectsFromArray:[NSArray safeArray:responseObject[@"Items"]]];
            [self.Favoritetable reloadData];
            _currentPage++;
            _PageCount = [responseObject[@"Paging"][@"PageCount"] integerValue] ;
            [self endPullUpRefresh];
        } else {
            [Progress progressShowcontent: @"获取收藏课程失败"];
        }
        [progress hiddenProgress];
    } failure:^(NSError *error) {
        [progress hiddenProgress];
        [KTMErrorHint showNetError:error inView:self.view];
    }];
}


#pragma mark - initTableView


- (void)initFavoriteTable {
    self.Favoritetable.delegate = self;
    self.Favoritetable.dataSource = self;
    [self.Favoritetable registerNib:[UINib nibWithNibName:@"FavoriteTableViewCell" bundle:nil]forCellReuseIdentifier:cellID];
    self.Favoritetable.rowHeight = UITableViewAutomaticDimension;
    self.Favoritetable.estimatedRowHeight = 70;
    [self initRefreshWithTableView:self.Favoritetable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.favoriteCourses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *courseInfo = [NSDictionary safeDictionary:self.favoriteCourses[indexPath.row]];
    [cell.logImageView setImageWithURL:[NSURL URLWithString:[NSString safeString:courseInfo[@"Cover"]]] placeholderImage:nil];
    cell.titleLabel.text = [NSString safeString:courseInfo[@"Name"]];
    cell.descriptionLable.text = [NSString safeString:courseInfo[@"Description"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *courseInfo = [NSDictionary safeDictionary:self.favoriteCourses[indexPath.row]];

    NSString *subTitle = [NSString safeString:courseInfo[@"Name"]];
    NSString *CourseId = [NSString safeString:courseInfo[@"Id"]];
    if (CourseId == nil) {
        [Progress progressShowcontent:@"此课程出现错误"];
        return;
    }
    HaventSignUpViewController *dvc = [[HaventSignUpViewController alloc]init];
    dvc.subTitle = subTitle;
    dvc.subId = CourseId;
    [self.navigationController pushViewController:dvc animated:YES];

}

#pragma mark - 初始化tableviewRefresh
- (void)initRefreshWithTableView:(UITableView *)tableView {
    // header
//    tableView.mj_header = [KTMRefreshHeader headerWithRefreshingBlock:^{
//        [self loadNewTaskWithTableView:tableView];
//    }];
//    
    // footer
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreCourse];
    }];
}

#pragma mark - 结束刷新
- (void)endPullUpRefresh {
    
    [self.Favoritetable.mj_footer endRefreshing];
    
}

//#pragma mark - 下拉刷新数据
//- (void)loadNewTaskWithTableView:(UITableView *)tableView {
//    if (isHeritalScroll) {
//        [tableView.mj_header endRefreshing];
//    } else {
//        if (tableView.mj_footer.state == MJRefreshStateNoMoreData) {
//            [tableView.mj_footer resetNoMoreData];
//        }
//    }
//}

#pragma mark - 上拉加载更多数据
- (void)loadMoreCourse {
    if (_currentPage == _PageCount) {
        [self.Favoritetable.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self getfavoriteCourse];
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
