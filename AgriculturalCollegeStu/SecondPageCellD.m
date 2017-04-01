//
//  SecondPageCellD.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondPageCellD.h"
#import "SubTableViewModel.h"
#import "UIImageView+AFNetworking.h"

@interface SecondPageCellD ()

@end

@implementation SecondPageCellD

@synthesize lbl_cellTitle;
@synthesize btn_toMore;

@synthesize lbl_upDesc;
@synthesize lbl_downDesc;

@synthesize imgv_down;
@synthesize btn_down;

@synthesize v_top;
@synthesize v_btm;

+ (instancetype) initViewLayout {
    
    SecondPageCellD *cell = [[[NSBundle mainBundle] loadNibNamed:@"second_page_cell_4" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) fillContent {
    
    SubTableViewModel *model_0 = _dataList[0];
    SubTableViewModel *model_1 = _dataList[1];
    
    [lbl_cellTitle setText:model_0.parentCategoryName];
    
    [lbl_upDesc setText:model_0.Description];
    [lbl_downDesc setText:model_1.Description];
    
    NSURL *cover_0 = [[NSURL alloc] initWithString:model_0.Cover];
    NSURL *cover_1 = [[NSURL alloc] initWithString:model_1.Cover];
    [imgv_down setImageWithURL:cover_1];
    
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self bringSubviewToFront:v_top];
    [self bringSubviewToFront:v_btm];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction) onMoreButtonClick:(id)sender {

    SubTableViewModel *model = _dataList[0];
    [self pushToListPage:model.parentCategoryId pageName:model.parentCategoryName];
}

@end
