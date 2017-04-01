//
//  MoreCourseViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/20.
//  Copyright © 2017年 YH. All rights reserved.
//

#import "MoreCourseViewController.h"
#import "CourseInfoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "HaventSignUpViewController.h"
#import "SetNavigationItem.h"

@interface MoreCourseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *courseTable;

@end
static NSString *cellID = @"cellId";
@implementation MoreCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:self.courseType subTitle:@""];
    [self initCourseTableView];
}


- (void)initCourseTableView {
    self.courseTable.delegate = self;
    self.courseTable.dataSource = self;
    [self.courseTable registerNib:[UINib nibWithNibName:@"CourseInfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCourseArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NSString *imgCover = self.allCourseArray[indexPath.row][@"Cover"];
    NSString *title = self.allCourseArray[indexPath.row][@"Name"];
    NSString *desc  = self.allCourseArray[indexPath.row][@"Description"];
    
    [cell.courseImage setImageWithURL:[NSURL URLWithString:imgCover]];
    cell.titleLabel.text = title;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *courseId = nil;
    NSString *pageCategoryId = nil;
    NSString *courseCover = nil;
    NSString *courseName = nil;
    courseId = self.allCourseArray[indexPath.row][@"Id"];
    courseCover = self.allCourseArray[indexPath.row][@"Cover"];
    //pageCategoryId = _entity.Id;
    courseName = self.allCourseArray[indexPath.row][@"Name"];
    
    UIStoryboard* storyboard =
    [UIStoryboard storyboardWithName:@"video_page" bundle:[NSBundle mainBundle]];
    
    //    VideoPageController *videoPageController = (VideoPageController *)[storyboard instantiateViewControllerWithIdentifier:@"video_page_controller"];
    //    videoPageController.courseId = courseId;
    //    videoPageController.pageCategoryId = pageCategoryId;
    //    videoPageController.courseCover = courseCover;
    //    videoPageController.isFromCache = NO;
    HaventSignUpViewController *haventView = [[HaventSignUpViewController alloc] init];
    haventView.subId = courseId;
    haventView.subTitle = courseName;
    [self.navigationController pushViewController:haventView animated:YES];
    


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
