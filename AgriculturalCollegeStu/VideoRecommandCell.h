//
//  VideoRecommandCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/23.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoRecommandCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_cover_bg;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_cover;
@property (weak, nonatomic) IBOutlet UIButton *btn_goin;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_count;

+ (instancetype) initViewLayout;

- (void) fillContent;


@end