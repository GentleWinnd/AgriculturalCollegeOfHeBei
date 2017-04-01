//
//  ChapterCellA.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseTableViewCell.h"
#import "ChapterCellA.h"

@implementation ChapterCellA
{

}

@synthesize lbl_groupName = _lbl_groupName;


+ (instancetype) initViewLayout {
    
    ChapterCellA *cell = [[[NSBundle mainBundle] loadNibNamed:@"chapter_cell_1" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end