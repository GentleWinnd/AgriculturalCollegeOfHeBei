//
//  FirstPageCellA.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/7.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstPageContentModel.h"
#import "HOMEBaseViewController.h"
#import "BaseTableViewCell.h"

@interface FirstPageCellA : BaseTableViewCell

@property(weak, nonatomic) IBOutlet UIView *topLayoutContainer;
@property(weak, nonatomic) IBOutlet UIView *btmLayoutContainer;

@property(weak, nonatomic) IBOutlet UIView *view_btm_left_item_container;
@property(weak, nonatomic) IBOutlet UIView *view_btm_center_item_container;
@property(weak, nonatomic) IBOutlet UIView *view_btm_right_item_container;

@property(weak, nonatomic) IBOutlet UIButton *btn_ToMore;
@property(weak, nonatomic) IBOutlet UILabel *lbl_CellTitle;

@property(weak, nonatomic) IBOutlet UIImageView *img_leftPic;
@property(weak, nonatomic) IBOutlet UIImageView *img_CenterPic;
@property(weak, nonatomic) IBOutlet UIImageView *img_RightPic;

@property(weak, nonatomic) IBOutlet UIButton *btn_leftItem;
@property(weak, nonatomic) IBOutlet UIButton *btn_CenterItem;
@property(weak, nonatomic) IBOutlet UIButton *btn_RightItem;

@property(weak, nonatomic) IBOutlet UILabel *lbl_leftTitle;
@property(weak, nonatomic) IBOutlet UILabel *lbl_centerTitle;
@property(weak, nonatomic) IBOutlet UILabel *lbl_rightTitle;
@property(weak, nonatomic) IBOutlet UILabel *lbl_leftDes;
@property(weak, nonatomic) IBOutlet UILabel *lbl_centerDes;
@property(weak, nonatomic) IBOutlet UILabel *lbl_rightDes;

@property(retain, nonatomic) FirstPageContentModel *entity;

- (IBAction) onButtonClick:(id)sender;

+ (instancetype) initViewLayout;

- (void) fillContent;

@end