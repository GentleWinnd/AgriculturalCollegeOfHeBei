//
//  ListPageViewController.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/27.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"

@interface ListPageViewController : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UIView *v_searchBarContainer;
@property (weak, nonatomic) IBOutlet UIView *v_searchBar;
@property (weak, nonatomic) IBOutlet UITextField *txtf_searchContent;
@property (weak, nonatomic) IBOutlet UIButton *btn_toSearch;
@property (weak, nonatomic) IBOutlet UIButton *btn_goBack;
@property (weak, nonatomic) IBOutlet UITableView *tabv_result;
@property (weak, nonatomic) IBOutlet UILabel *lbl_emptyResult;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@property (strong, nonatomic) UIViewController *parentVc;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSMutableArray *categoryList;
@property (strong, nonatomic) NSMutableArray *searchResultList;
@property (strong, nonatomic) NSString *subCategoryId;
@property (strong, nonatomic) NSString *subCategoryName;

- (IBAction) toSearch:(id)sender;
- (IBAction) goBack:(id)sender;

@end
