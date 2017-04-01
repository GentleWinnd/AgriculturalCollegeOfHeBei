//
//  ChapterSuperCellB.m
//  xingxue_pro
//
//  Created by 张磊 on 16/5/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"
#import "ChapterSuperCellB.h"


@interface ChapterSuperCellB ()

@end

@implementation ChapterSuperCellB
{
    
}

+ (instancetype) initViewLayout {
    
    ChapterSuperCellB *cell = [[[NSBundle mainBundle] loadNibNamed:@"chapter_super_cell_2" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) fillContent {

    _scl_courseDesc.contentSize = CGSizeMake(WIDTH - 16, 300);
    UITextView *lbl_ourseDesc = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 16, 300)];
    [lbl_ourseDesc setUserInteractionEnabled:NO];
    UIFont *font = [UIFont fontWithName:@"Microsoft Yahei" size:13];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    lbl_ourseDesc.attributedText = [[NSAttributedString alloc] initWithString:_courseDesc attributes:attributes];
    [lbl_ourseDesc setTextColor:[UIColor grayColor]];
    
    [_scl_courseDesc addSubview:lbl_ourseDesc];
    
    [_imgv_avatar setImageWithURL:[NSURL URLWithString:_teacherModel.Photo].absoluteURL];
    [_lbl_name setText:_teacherModel.FullName];
    [_lbl_info setText:_teacherModel.Description];
}

@end