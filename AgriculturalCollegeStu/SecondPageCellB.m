//
//  SecondPageCellB.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondPageCellB.h"
#import "SubTableViewModel.h"
#import "UIImageView+AFNetworking.h"

@interface SecondPageCellB ()

@end

@implementation SecondPageCellB

@synthesize v_top_title_bar;
@synthesize v_btm_content;

@synthesize lbl_cellTitle;
@synthesize btn_toMore;

@synthesize imgv_left;
@synthesize imgv_center;
@synthesize imgv_right;

@synthesize btn_left;
@synthesize btn_center;
@synthesize btn_right;

@synthesize lbl_bottom_desc;

@synthesize dataList = _dataList;

+ (instancetype) initViewLayout {
    
    SecondPageCellB *cell = [[[NSBundle mainBundle] loadNibNamed:@"second_page_cell_2" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) fillContent {
    
    SubTableViewModel *model_0 = _dataList[0];
    SubTableViewModel *model_1 = _dataList[1];
    SubTableViewModel *model_2 = _dataList[2];
    
    [lbl_cellTitle setText:model_0.parentCategoryName];
    [lbl_bottom_desc setText:model_0.Description];
    
    NSURL *cover_0 = [[NSURL alloc] initWithString: model_0.Cover];
    NSURL *cover_1 = [[NSURL alloc] initWithString: model_1.Cover];
    NSURL *cover_2 = [[NSURL alloc] initWithString: model_2.Cover];
    
    [imgv_left setImageWithURL:cover_0];
    [imgv_center setImageWithURL:cover_1];
    [imgv_right setImageWithURL:cover_2];
    
    btn_left.tag = 0;
    btn_center.tag = 1;
    btn_right.tag = 2;
    
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self bringSubviewToFront:v_btm_content];
    [self bringSubviewToFront:v_top_title_bar];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction) onItemClickEvent:(id)sender {

    int index = (int)[sender tag];
    SubTableViewModel *model = _dataList[index];
    
    [self pushToVideoPage:model.Id courseCover:model.Cover pageCategoryId:model.parentCategoryId];
}

- (IBAction) onMoreButtonClick:(id)sender {
    SubTableViewModel *model = _dataList[0];
    [self pushToListPage:model.parentCategoryId pageName:model.parentCategoryName];
}
    
@end