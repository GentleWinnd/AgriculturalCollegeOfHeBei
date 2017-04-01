//
//  ListCell.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/25.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListCell.h"
#import "VideoPageModel.h"
#import "UIImageView+AFNetworking.h"


@interface  ListCell()

@end

@implementation ListCell
{

}

@synthesize lbl_title = _lbl_title;
@synthesize lbl_desc = _lbl_desc;
@synthesize lbl_num = _lbl_num;
@synthesize imgv_leftIcon = _imgv_leftIcon;
@synthesize v_random;


+ (instancetype) initViewLayout {
    
    ListCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"list_cell" owner:nil options:nil] lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    int redInz = (arc4random() % 255) + 1;
    int greenInz = (arc4random() % 255) + 1;
    int blueInz = (arc4random() % 255) + 1;
    
    UIColor *color =
    [UIColor colorWithRed:redInz/255.0 green:greenInz/255.0 blue:blueInz/255.0f alpha:1.0f];
    [v_random setBackgroundColor:color];
    
    _lbl_num.layer.cornerRadius = 8;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) fillContent:(VideoPageModel *) model {

    [_lbl_desc setText:model.Information];
    [_lbl_title setText:model.Name];
    [_lbl_num setText:model.Period];
    [_imgv_leftIcon setImageWithURL:[[NSURL alloc] initWithString:model.Cover]];
    
}


@end