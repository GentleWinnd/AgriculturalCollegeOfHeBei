//
//  SecondPageCellA.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/13.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondPageCellA.h"
#import "SubTableViewModel.h"
#import "UIImageView+AFNetworking.h"

@interface SecondPageCellA ()

@end

@implementation SecondPageCellA

@synthesize view_topContainer;
@synthesize view_btmContainer;

@synthesize lbl_cellTitle;
@synthesize btn_toMore;

@synthesize btn_line1left;
@synthesize btn_line1right;
@synthesize btn_line2left;
@synthesize btn_line2right;

@synthesize imgv_line1left;
@synthesize imgv_line1right;
@synthesize imgv_line2left;
@synthesize imgv_line2right;

@synthesize lbl_line1leftTitle;
@synthesize lbl_line1rightTitle;
@synthesize lbl_line2leftTitle;
@synthesize lbl_line2rightTitle;

@synthesize lbl_line1leftDesc;
@synthesize lbl_line1rightDesc;
@synthesize lbl_line2leftDesc;
@synthesize lbl_line2rightDesc;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

+ (instancetype) initViewLayout {
    
    SecondPageCellA *cell = [[[NSBundle mainBundle] loadNibNamed:@"second_page_cell_1" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) fillContent {
    
    SubTableViewModel *model_0 = _dataList[0];
    SubTableViewModel *model_1 = _dataList[1];
    SubTableViewModel *model_2 = _dataList[2];
    SubTableViewModel *model_3 = _dataList[3];
    
    [lbl_cellTitle setText:model_0.parentCategoryName];
    
    NSURL *cover_0 = [[NSURL alloc] initWithString: model_0.Cover];
    NSURL *cover_1 = [[NSURL alloc] initWithString: model_1.Cover];
    NSURL *cover_2 = [[NSURL alloc] initWithString: model_2.Cover];
    NSURL *cover_3 = [[NSURL alloc] initWithString: model_3.Cover];
    [imgv_line1left setImageWithURL:cover_0];
    [imgv_line1right setImageWithURL:cover_1];
    [imgv_line2left setImageWithURL:cover_2];
    [imgv_line2right setImageWithURL:cover_3];
    
    [lbl_line1leftTitle setText:model_0.Name];
    [lbl_line1rightTitle setText:model_1.Name];
    [lbl_line2leftTitle setText:model_2.Name];
    [lbl_line2rightTitle setText:model_3.Name];
    
    [lbl_line1leftDesc setText:model_0.Description];
    [lbl_line1rightDesc setText:model_1.Description];
    [lbl_line2leftDesc setText:model_2.Description];
    [lbl_line2rightDesc setText:model_3.Description];
    
    btn_line1left.tag = 0;
    btn_line1right.tag = 1;
    btn_line2left.tag = 2;
    btn_line2right.tag = 3;
    
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    [self bringSubviewToFront:view_btmContainer];
    [self bringSubviewToFront:view_topContainer];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction) onClickevent:(id)sender {
    
    SubTableViewModel *model = _dataList[[sender tag]];
    [self pushToVideoPage:model.Id courseCover:model.Cover pageCategoryId:model.parentCategoryId];
}

- (IBAction) onMoreButtonClick:(id)sender {
    SubTableViewModel *model = _dataList[0];
    [self pushToListPage:model.parentCategoryId pageName:model.parentCategoryName];
}

@end