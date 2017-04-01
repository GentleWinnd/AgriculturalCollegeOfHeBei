//
//  CategoryMenuCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/20.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *v_left;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

+ (instancetype) initViewLayout;

@end
