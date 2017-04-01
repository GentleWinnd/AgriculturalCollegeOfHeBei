//
//  CategoryMenuCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/20.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryMenuCell.h"


@interface  CategoryMenuCell()

@end

@implementation CategoryMenuCell

@synthesize v_left = _v_left;
@synthesize lbl_name = _lbl_name;

+ (instancetype) initViewLayout {

    CategoryMenuCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"category_list_menu_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    int redInz = (arc4random() % 255) + 1;
    int greenInz = (arc4random() % 255) + 1;
    int blueInz = (arc4random() % 255) + 1;
    
    UIColor *color =
    [UIColor colorWithRed:redInz/255.0 green:greenInz/255.0 blue:blueInz/255.0f alpha:1.0f];
    [_v_left setBackgroundColor:color];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
