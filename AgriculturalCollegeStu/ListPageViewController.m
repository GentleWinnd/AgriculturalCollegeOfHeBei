//
//  ListPageViewController.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListPageViewController.h"
#import "Header_key.h"
#import "ListCell.h"
#import "SubTableViewModel.h"

@interface ListPageViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ListPageViewController
{
    CATransition *animation;
}

@synthesize v_searchBarContainer;
@synthesize v_searchBar;
@synthesize txtf_searchContent;
@synthesize btn_toSearch;
@synthesize btn_goBack;
@synthesize tabv_result;
@synthesize lbl_emptyResult;
@synthesize lbl_title;
@synthesize parentVc;
@synthesize listData;
@synthesize categoryList;
@synthesize searchResultList;
@synthesize subCategoryId;
@synthesize subCategoryName;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    tabv_result.hidden = YES;
    tabv_result.delegate = self;
    tabv_result.dataSource = self;
    tabv_result.separatorStyle = NO;
    tabv_result.showsVerticalScrollIndicator = NO;
    
    animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //animation.type = @"pageCurl";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    
    if(subCategoryName != nil) [lbl_title setText:subCategoryName];
    
    if(subCategoryId != nil && ![subCategoryId isEqualToString:@""] ) {
        [self loadCategroyList:subCategoryId];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    v_searchBarContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    v_searchBarContainer.layer.shadowOffset = CGSizeMake(0, 1);
    v_searchBarContainer.layer.shadowOpacity = 0.5;
    v_searchBarContainer.layer.shadowRadius = 1;
    
    v_searchBar.layer.cornerRadius = 16;
    v_searchBar.clipsToBounds = YES;
}

- (IBAction) toSearch:(id)sender {
    NSString *keyword = txtf_searchContent.text;
    [self loadSreachList:keyword];
}

- (IBAction) goBack:(id)sender {
    
    if(searchResultList.count != 0) {
        listData = categoryList;
        [tabv_result reloadData];
        [searchResultList removeAllObjects];
    } else {
        [self.view.window.layer addAnimation:animation forKey:nil];
        [parentVc dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void) loadCategroyList:(NSString *) subId {
    
    categoryList = [NSMutableArray array];
    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [_AFNManager GET:[NSString stringWithFormat:URL_COURSE_LIST, subId, @"MVC", 1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//
//        for (NSDictionary *dict in dic[@"PageListInfos"]) {
//            SubTableViewModel *model = [[SubTableViewModel alloc]init];
//            model.Id = dict[@"Id"];
//            model.Name = dict[@"Name"];
//            model.Description = dict[@"Description"];
//            model.Period = dict[@"Period"];
//            model.Cover = dict[@"Cover"];
//            model.parentCategoryId = subId;
//            [categoryList addObject:model];
//        }
//        
//        if(categoryList.count != 0) {
//            listData = categoryList;
//            [tabv_result reloadData];
//            tabv_result.hidden = NO;
//        } else {
//            tabv_result.hidden = YES;
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [lbl_emptyResult setText:@"加载分类信息失败"];
//        tabv_result.hidden = YES;
//    }];
//
}


- (void) loadSreachList:(NSString *) _keyWords {
    
    searchResultList = [NSMutableArray array];
    
    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *keyword = [_keyWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [_AFNManager GET:[NSString stringWithFormat:URL_COURSE_SEARCH, keyword, @"CreateDate", 1]parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//
//        for (NSDictionary *dic in dict[@"PageListInfos"]) {
//            if ([dic[@"Id"] length] >0){
//                SubTableViewModel *model = [[SubTableViewModel alloc]init];
//                model.Id = dic[@"Id"];
//                model.Name = dic[@"Name"];
//                model.Description = dic[@"Description"];
//                model.Period = dic[@"Period"];
//                model.Cover = dic[@"Cover"];
//                model.parentCategoryId = @"-";
//                [searchResultList addObject:model];
//            }
//        }
//        
//        if(searchResultList.count != 0) {
//            listData = searchResultList;
//            [tabv_result reloadData];
//            tabv_result.hidden = NO;
//        } else {
//            NSLog(@"0 个搜索结果！");
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        [lbl_emptyResult setText:@"加载数据失败"];
//    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(listData != nil) return listData.count;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubTableViewModel *model = [listData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"history_list_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        ListCell *lc = [ListCell initViewLayout];
        lc.myParentViewController = self;
        [lc.lbl_desc setText:model.Description];
        [lc.lbl_title setText:model.Name];
        [lc.lbl_num setText:[NSString stringWithFormat:@"%@集", model.Period]];
        [lc.imgv_leftIcon setImageWithURL:[[NSURL alloc] initWithString:model.Cover]];
        cell = lc;
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubTableViewModel *model = [listData objectAtIndex:indexPath.row];
    ListCell *currentCell = (ListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [currentCell pushToVideoPage:model.Id courseCover:model.Cover pageCategoryId:model.parentCategoryId];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}



@end
