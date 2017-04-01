//
//  SecondPageCellC.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondPageCellC.h"
#import "SubTableViewModel.h"
#import "UIImageView+AFNetworking.h"

@interface SecondPageCellC ()

@end

@implementation SecondPageCellC

@synthesize lbl_subTitle = _lbl_subTitle;
@synthesize lbl_subDesc = _lbl_subDesc;

@synthesize btn_center = _btn_center;
@synthesize imgv_center = _imgv_center;

@synthesize lbl_cellTitle = _lbl_cellTitle;
@synthesize btn_toMore = _btn_toMore;

@synthesize v_top = _v_top;
@synthesize v_btm = _v_btm;

@synthesize dataList = _dataList;

+ (instancetype) initViewLayout {
    
    SecondPageCellC *cell = [[[NSBundle mainBundle] loadNibNamed:@"second_page_cell_3" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) fillContent {
    
    SubTableViewModel *model_0 = _dataList[0];
    
    [_lbl_cellTitle setText:model_0.parentCategoryName];
    [_lbl_subTitle setText:model_0.Name];
    [_lbl_subDesc setText:model_0.Description];
    NSURL *imgCover = [[NSURL alloc] initWithString:model_0.Cover];
    [_imgv_center setImageWithURL:imgCover];

}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [_v_top setUserInteractionEnabled:YES];
    [_v_btm setUserInteractionEnabled:YES];
    
    [self bringSubviewToFront:_v_top];// *重要*
    [self bringSubviewToFront:_v_btm];// *重要* 去掉按钮将会无法响应点击事件
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction) onCenterIconClick:(id)sender {
    SubTableViewModel *model_0 = _dataList[0];
    [self pushToVideoPage:model_0.Id courseCover:model_0.Cover pageCategoryId:model_0.parentCategoryId];
}

- (IBAction) onMoreButtonClick:(id)sender {

    SubTableViewModel *model_0 = _dataList[0];
    [self pushToListPage:model_0.parentCategoryId pageName:model_0.parentCategoryName];
}


@end