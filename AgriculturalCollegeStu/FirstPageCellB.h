//
//  FirstPageCellB.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FirstPageContentModel.h"
#import "BaseTableViewCell.h"

@interface FirstPageCellB : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *view_top_container;
@property (weak, nonatomic) IBOutlet UIView *view_btm_container;

@property (weak, nonatomic) IBOutlet UILabel *lbl_cellTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_toMore;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_top;
@property (weak, nonatomic) IBOutlet UIButton *btn_top;
@property (weak, nonatomic) IBOutlet UILabel *lbl_top;
@property (weak, nonatomic) IBOutlet UIView *view_top_view;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_line1left;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line2left;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line3left;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_line1right;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line2right;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line3right;

@property (weak, nonatomic) IBOutlet UIButton *btn_line1left;
@property (weak, nonatomic) IBOutlet UIButton *btn_line2left;
@property (weak, nonatomic) IBOutlet UIButton *btn_line3left;
@property (weak, nonatomic) IBOutlet UIButton *btn_line1right;
@property (weak, nonatomic) IBOutlet UIButton *btn_line2right;
@property (weak, nonatomic) IBOutlet UIButton *btn_line3right;


@property (weak, nonatomic) IBOutlet UILabel *lbl_line1left_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2left_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line3left_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line1right_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2right_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line3right_title;

@property (weak, nonatomic) IBOutlet UILabel *lbl_line1left_des;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2left_des;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line3left_des;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line1right_des;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2right_des;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line3right_des;

@property (weak, nonatomic) IBOutlet UILabel *lbl_line1left_count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2left_count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line3left_count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line1right_count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2right_count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line3right_count;
@property (weak, nonatomic) IBOutlet UILabel *lbl_top_count;

@property(retain, nonatomic) FirstPageContentModel *entity;

+ (instancetype) initViewLayout;

- (IBAction) onBtnClick:(id)sender;

- (void) fillContent;

@end