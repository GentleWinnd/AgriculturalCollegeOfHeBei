//
//  CourseInfoTableViewController.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/23.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "CourseInfoTableViewController.h"
#import "SubTableViewModel.h"
#import "SecondPageCellC.h"
#import "SecondPageCellA.h"
#import "SecondPageCellB.h"
#import "SecondPageCellD.h"
#import "SetNavigationItem.h"

@interface CourseInfoTableViewController ()
{
    NSMutableArray *categroyList;
}
@property (nonatomic, strong) NSMutableDictionary *pageContentMap;

@end

@implementation CourseInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[SetNavigationItem shareSetNavManager] setNavTitle:self withTitle:@"课程详情" subTitle:@""];
    [self initData];
    [self getALLCourseList];
}

#pragma mark - initData 
- (void)initData {
    categroyList = [NSMutableArray arrayWithCapacity:0];
    _pageContentMap = [NSMutableDictionary dictionaryWithCapacity:0];
}

#pragma mark - 获取所有的课程

- (void)getALLCourseList {
    [NetServiceAPI getALLCourseListWithParameters:nil success:^(id responseObject) {
        
        for (NSDictionary *subDic in responseObject[@"Children"]) {
            if ([subDic[@"Id"] isEqualToString:_categroyId]) {
                [categroyList addObjectsFromArray:subDic[@"Children"]];
                
                for(int i = 0; i < categroyList.count; i ++) {
                    
                    [self loadPageSubListInfo:categroyList[i][@"Id"] subCategoryName:categroyList[i][@"Name"]];
                    
                }
                
                //                [_contentTableView reloadData];
                //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                //                [_categoryTableView selectRowAtIndexPath:indexPath animated:NO        scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        NSLog(@"%@", error.description);
    }];
    
}

#pragma mark - 获取下部的课程详情

- (void) loadPageSubListInfo:(NSString *) subCategoryId subCategoryName:(NSString *) name {
   
    NSDictionary *parameter = @{@"URL": subCategoryId};
    [NetServiceAPI getSubCourseListWithParameters:parameter success:^(id responseObject) {
        NSMutableArray *pageSubContentList = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in responseObject[@"PageListInfos"]) {
            SubTableViewModel *model = [[SubTableViewModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.parentCategoryName = name;
            model.parentCategoryId = subCategoryId;
            [pageSubContentList addObject:model];
        }
        
        if(pageSubContentList != nil && pageSubContentList.count != 0) {
            
            NSInteger subItemCount = pageSubContentList.count;
            if(subItemCount > 4) subItemCount = 4;
            int value = (arc4random() % subItemCount) + 1;
            
            ((SubTableViewModel *) pageSubContentList[0]).cellType = value;
            
            [_pageContentMap setObject:pageSubContentList forKey:subCategoryId];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [KTMErrorHint showNetError:error inView:self.view];
        NSLog(@"%@", error.description);
    }];
}


#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _pageContentMap.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *keys = [_pageContentMap allKeys];
    NSArray *subDataList = [_pageContentMap objectForKey:keys[indexPath.row]];
    int type = ((SubTableViewModel *) subDataList[0]).cellType;
    
    static NSString *CellIdentifier = @"second_page_super_cell_content";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        if(type == 1) {
            
            cell = [self getCellC:subDataList];
            
        } else if(type == 2) {
            
            cell = [self getCellD:subDataList];
            
        } else if(type == 3) {
            
            cell = [self getCellB:subDataList];
            
        } else if(type == 4) {
            
            cell = [self getCellA:subDataList];
            
        } else {
            
            cell = [self getCellC:subDataList];
            
        }
        
    }
    
    return cell;
    
}


/**
 4 item
 */
- (UITableViewCell *) getCellA:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellA initViewLayout];
    ((SecondPageCellA *) cell).dataList = dataList;
    ((SecondPageCellA *) cell).myParentViewController = self;
    [((SecondPageCellA *) cell) fillContent];
    return cell;
    
}


/**
 3 item
 */
- (UITableViewCell *) getCellB:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellB initViewLayout];
    ((SecondPageCellB *) cell).dataList = dataList;
    ((SecondPageCellB *) cell).myParentViewController = self;
    [((SecondPageCellB *) cell) fillContent];
    return cell;
    
}

/**
 1 item
 */
- (UITableViewCell *) getCellC:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellC initViewLayout];
    ((SecondPageCellC *) cell).dataList = dataList;
    ((SecondPageCellC *) cell).myParentViewController = self;
    [((SecondPageCellC *) cell) fillContent];
    return cell;
    
}

/**
 2 item
 */
- (UITableViewCell *) getCellD:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellD initViewLayout];
    ((SecondPageCellD *) cell).dataList = dataList;
    ((SecondPageCellD *) cell).myParentViewController = self;
    [((SecondPageCellD *) cell) fillContent];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"000000000");
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //    FirstPageSearchBarCell *headerCell = [FirstPageSearchBarCell initViewLayout];
    //    return headerCell;
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.row == 0) return 200;
    //    else if(indexPath.row == 1) return 260;
    //    else if(indexPath.row > 1) return 740;
    //    else return 220;
    
    NSArray *keys = [_pageContentMap allKeys];
    NSArray *subDataList = [_pageContentMap objectForKey:keys[indexPath.row]];
    int type = ((SubTableViewModel *) subDataList[0]).cellType;
    
    if(type == 1) {
        return 300.0;
    } else if (type == 2) {
        return 250.0;
    } else if (type == 3) {
        return 200;
    } else if (type == 4) {
        return 380.0;
    }
    
    return 320;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
