//
//  DotCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/19.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotCell.h"


@interface  DotCell()

@end

@implementation DotCell

@synthesize v_normal;
@synthesize v_selected;


+ (instancetype) initViewLayout {
    
    DotCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"course_dots_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    //v_selected.layer.cornerRadius = 1;
    v_selected.hidden = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end