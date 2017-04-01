//
//  SecondPageCellD.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface SecondPageCellD : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_cellTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_toMore;

@property (weak, nonatomic) IBOutlet UILabel *lbl_upDesc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_downDesc;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_down;
@property (weak, nonatomic) IBOutlet UIButton *btn_down;

@property (weak, nonatomic) IBOutlet UIView *v_top;
@property (weak, nonatomic) IBOutlet UIView *v_btm;

@property (retain, nonatomic) NSArray *dataList;

+ (instancetype) initViewLayout;

- (void) fillContent;


@end
