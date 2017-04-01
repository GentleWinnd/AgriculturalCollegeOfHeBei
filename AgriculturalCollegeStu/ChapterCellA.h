//
//  ChapterCellA.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseTableViewCell.h"

@interface ChapterCellA : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_groupName;

+ (instancetype) initViewLayout;

@end