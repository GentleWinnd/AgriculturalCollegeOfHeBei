//
//  SecondPageCellB.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface SecondPageCellB : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *v_top_title_bar;
@property (weak, nonatomic) IBOutlet UIView *v_btm_content;

@property (weak, nonatomic) IBOutlet UILabel *lbl_cellTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_toMore;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_left;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_center;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_right;

@property (weak, nonatomic) IBOutlet UIButton *btn_left;
@property (weak, nonatomic) IBOutlet UIButton *btn_center;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;

@property (weak, nonatomic) IBOutlet UILabel *lbl_bottom_desc;


@property (retain, nonatomic) NSArray *dataList;

+ (instancetype) initViewLayout;

- (void) fillContent;

- (IBAction) onItemClickEvent:(id)sender;


@end
