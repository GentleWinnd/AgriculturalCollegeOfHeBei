//
//  SecondPageSuperCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondPageSuperCell.h"
#import "AFHTTPSessionManager.h"
#import "HOMEHeader.h"
#import "SubTableViewModel.h"
#import "SecondPageCellC.h"
#import "SecondPageCellA.h"
#import "SecondPageCellB.h"
#import "SecondPageCellD.h"


@interface SecondPageSuperCell ()

@end

@implementation SecondPageSuperCell {

    NSMutableArray *array_1;
    NSMutableArray *array_2;
    NSMutableArray *array_3;
    NSMutableArray *array_4;
    
}

@synthesize categroyId = _categroyId;
@synthesize categroyList = _categroyList;
@synthesize categroyAllMap = _categroyAllMap;
@synthesize contentTableView = _contentTableView;
@synthesize pageContentMap = _pageContentMap;
@synthesize itemTypeMap = _itemTypeMap;

+ (instancetype) initViewLayout {
    
    SecondPageSuperCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"second_page_super_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    [self bringSubviewToFront:_contentTableView];
    
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorStyle = NO;
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.hidden = YES;
    
    [_actvi_loadingbar startAnimating];
    
    [self loadPageInfo];
}

- (void) loadPageInfo {
    
    _actvi_loadingbar.hidden = NO;
    _pageContentMap = [[NSMutableDictionary alloc] init];
    _itemTypeMap = [[NSMutableDictionary alloc] init];
    
//    AFHTTPRequestOperationManager * _AFNManager = [AFHTTPRequestOperationManager manager];
//    _AFNManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [_AFNManager GET:[NSString stringWithFormat:@"%@%@", URL_BASE, URL_CATEGORY_ALL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        _categroyAllMap = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        for (NSDictionary *subDic in _categroyAllMap[@"Children"]) {
//            if ([subDic[@"Id"] isEqualToString:_categroyId]) {
//                _categroyList = [NSArray arrayWithArray:subDic[@"Children"]];
//                
//                for(int i = 0; i < _categroyList.count; i ++) {
//                    
//                    [self loadPageSubListInfo:_categroyList[i][@"Id"] subCategoryName:_categroyList[i][@"Name"]];
//                    
//                }
//                
////                [_contentTableView reloadData];
////                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
////                [_categoryTableView selectRowAtIndexPath:indexPath animated:NO        scrollPosition:UITableViewScrollPositionNone];
//                break;
//            }
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error.localizedDescription);
//    }];

}

- (void) loadPageSubListInfo:(NSString *) subCategoryId subCategoryName:(NSString *) name {
//    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:[NSString stringWithFormat:URL_COURSE_LIST, subCategoryId, @"MVC", 1] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        [_subTableView.header endRefreshing];
////        [_subTableView.footer endRefreshing];
//        //        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////        if (_flag == 1) {
////            [_dataArr removeAllObjects];
////        }
//        
//        NSMutableArray *pageSubContentList = [[NSMutableArray alloc] init];
//        
//        for (NSDictionary *dict in dic[@"PageListInfos"]) {
//            SubTableViewModel *model = [[SubTableViewModel alloc] init];
//            [model setValuesForKeysWithDictionary:dict];
//            model.parentCategoryName = name;
//            model.parentCategoryId = subCategoryId;
//            [pageSubContentList addObject:model];
//        }
//        
//        if(pageSubContentList != nil && pageSubContentList.count != 0) {
//
//            NSInteger subItemCount = pageSubContentList.count;
//            if(subItemCount > 4) subItemCount = 4;
//            int value = (arc4random() % subItemCount) + 1;
//            
//            ((SubTableViewModel *) pageSubContentList[0]).cellType = value;
//            
//            [_pageContentMap setObject:pageSubContentList forKey:subCategoryId];
//        }
//        
//        [_contentTableView reloadData];
//        
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTabv) userInfo:nil repeats:NO];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        [_subTableView.header endRefreshing];
////        [_subTableView.footer endRefreshing];
//    }];
    
}

- (void) showTabv {
    _actvi_loadingbar.hidden = YES;
    _contentTableView.hidden = NO;
}


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
    ((SecondPageCellA *) cell).myParentViewController = self.myParentViewController;
    [((SecondPageCellA *) cell) fillContent];
    return cell;
    
}


/**
 3 item
 */
- (UITableViewCell *) getCellB:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellB initViewLayout];
    ((SecondPageCellB *) cell).dataList = dataList;
    ((SecondPageCellB *) cell).myParentViewController = self.myParentViewController;
    [((SecondPageCellB *) cell) fillContent];
    return cell;
    
}

/**
 1 item
 */
- (UITableViewCell *) getCellC:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellC initViewLayout];
    ((SecondPageCellC *) cell).dataList = dataList;
    ((SecondPageCellC *) cell).myParentViewController = self.myParentViewController;
    [((SecondPageCellC *) cell) fillContent];
    return cell;
    
}

/**
 2 item
 */
- (UITableViewCell *) getCellD:(NSArray *) dataList {
    
    UITableViewCell *cell = [SecondPageCellD initViewLayout];
    ((SecondPageCellD *) cell).dataList = dataList;
    ((SecondPageCellD *) cell).myParentViewController = self.myParentViewController;
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


@end
