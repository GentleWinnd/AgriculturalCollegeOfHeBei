//
//  EpisodesCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/22.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *v_rect;
@property (weak, nonatomic) IBOutlet UILabel *lbl_numb;

+ (instancetype) initViewLayout;

@end
