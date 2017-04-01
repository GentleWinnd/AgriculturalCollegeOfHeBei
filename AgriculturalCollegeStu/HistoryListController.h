//
//  HistoryListController.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/25.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"

@interface HistoryListController : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UIView *v_titleContainer;
@property (weak, nonatomic) IBOutlet UIView *v_bottomContainer;
@property (weak, nonatomic) IBOutlet UITableView *tbv_listTabv;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@property (strong, nonatomic) UIViewController *minePageViewController;
@property (assign, nonatomic) BOOL isTobeFavoritePage;

- (IBAction) backClick:(id)sender;


@end
