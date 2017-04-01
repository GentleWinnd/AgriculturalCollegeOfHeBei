//
//  FirstPageTitleTableViewCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstPageTitleTableViewCell.h"


@interface FirstPageTitleTableViewCell ()

@end

@implementation FirstPageTitleTableViewCell

@synthesize lbl_title = _lbl_title;
@synthesize imgv_pointer = _imgv_pointer;

- (void) awakeFromNib {

    [super awakeFromNib];
    _lbl_title.font = [UIFont fontWithName:@"Microsoft Yahei" size:16];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

+ (instancetype) initViewLayout {

    FirstPageTitleTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"first_page_title_cell" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) setTitleName:(NSString *) titleName {
    
    [_lbl_title setText:titleName];
    
}

@end