//
//  SecondPageCellA.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface SecondPageCellA : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *view_topContainer;
@property (weak, nonatomic) IBOutlet UIView *view_btmContainer;

@property (weak, nonatomic) IBOutlet UILabel *lbl_cellTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_toMore;

@property (weak, nonatomic) IBOutlet UIButton *btn_line1left;
@property (weak, nonatomic) IBOutlet UIButton *btn_line1right;
@property (weak, nonatomic) IBOutlet UIButton *btn_line2left;
@property (weak, nonatomic) IBOutlet UIButton *btn_line2right;

@property (weak, nonatomic) IBOutlet UIImageView *imgv_line1left;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line1right;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line2left;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_line2right;

@property (weak, nonatomic) IBOutlet UILabel *lbl_line1leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line1rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2rightTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_line1leftDesc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line1rightDesc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2leftDesc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_line2rightDesc;


@property (retain, nonatomic) NSArray *dataList;

+ (instancetype) initViewLayout;

- (void) fillContent;

- (IBAction) onClickevent:(id)sender;

@end