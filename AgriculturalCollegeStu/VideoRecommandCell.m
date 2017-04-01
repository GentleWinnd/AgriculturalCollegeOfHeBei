//
//  VideoRecommandCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/23.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoRecommandCell.h"

@interface VideoRecommandCell ()

@end

@implementation VideoRecommandCell

@synthesize imgv_cover = _imgv_cover;
@synthesize imgv_cover_bg = _imgv_cover_bg;
@synthesize btn_goin = _btn_goin;
@synthesize lbl_title = _lbl_title;
@synthesize lbl_count = _lbl_count;


+ (instancetype) initViewLayout {
    
    VideoRecommandCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"video_recommand_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) fillContent {
    
    
    
}

@end