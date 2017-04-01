//
//  ListCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/25.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPageModel.h"
#import "BaseTableViewCell.h"

@interface ListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_desc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_leftIcon;
@property (weak, nonatomic) IBOutlet UIView *v_random;


+ (instancetype) initViewLayout;

- (void) fillContent:(VideoPageModel *) model;

@end
