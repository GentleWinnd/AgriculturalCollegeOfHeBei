//
//  DotCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/19.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *v_normal;
@property (weak, nonatomic) IBOutlet UIView *v_selected;

+ (instancetype) initViewLayout;

@end