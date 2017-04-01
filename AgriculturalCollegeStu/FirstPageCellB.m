//
//  FirstPageCellB.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstPageCellB.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface FirstPageCellB ()

@end

@implementation FirstPageCellB

@synthesize view_top_container;
@synthesize view_btm_container;

@synthesize lbl_cellTitle;
@synthesize btn_toMore;

@synthesize imgv_top;
@synthesize btn_top;
@synthesize lbl_top;
@synthesize view_top_view;

@synthesize imgv_line1left;
@synthesize imgv_line2left;
@synthesize imgv_line3left;

@synthesize imgv_line1right;
@synthesize imgv_line2right;
@synthesize imgv_line3right;

@synthesize btn_line1left;
@synthesize btn_line2left;
@synthesize btn_line3left;
@synthesize btn_line1right;
@synthesize btn_line2right;
@synthesize btn_line3right;


@synthesize lbl_line1left_title;
@synthesize lbl_line2left_title;
@synthesize lbl_line3left_title;
@synthesize lbl_line1right_title;
@synthesize lbl_line2right_title;
@synthesize lbl_line3right_title;

@synthesize lbl_line1left_des;
@synthesize lbl_line2left_des;
@synthesize lbl_line3left_des;
@synthesize lbl_line1right_des;
@synthesize lbl_line2right_des;
@synthesize lbl_line3right_des;

@synthesize lbl_line1left_count;
@synthesize lbl_line2left_count;
@synthesize lbl_line3left_count;
@synthesize lbl_line1right_count;
@synthesize lbl_line2right_count;
@synthesize lbl_line3right_count;
@synthesize lbl_top_count;

@synthesize entity = _entity;

- (void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"load layout for FirstPage cell B");
    [self setUserInteractionEnabled:YES];
    [view_top_container setUserInteractionEnabled:YES];
    [view_top_container setUserInteractionEnabled:YES];
    
    [self bringSubviewToFront:view_top_container];
    [self bringSubviewToFront:view_btm_container];
    
    btn_top.tag = 0;
    btn_line1left.tag = 1;
    btn_line1right.tag = 2;
    btn_line2left.tag = 3;
    btn_line2right.tag = 4;
    btn_line3left.tag = 5;
    btn_line3right.tag = 6;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction) onBtnClick:(id)sender {
    
    int index = (int) [sender tag];
    NSString *courseId = _entity.Courses[index][@"Id"];
    NSString *cover = _entity.Courses[index][@"Cover"];
    NSString *categoryId = _entity.Id;
    
    [self pushToVideoPage:courseId courseCover:cover pageCategoryId:categoryId];

}

+ (instancetype) initViewLayout {
    
    FirstPageCellB *cell = [[[NSBundle mainBundle] loadNibNamed:@"first_page_cell_2" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) fillContent {

    int randomIndex = self.randomValue;
    if(randomIndex >= _entity.Courses.count || randomIndex + 6 >= _entity.Courses.count) {
        randomIndex = (int) _entity.Courses.count - 7;
    }
    
    [lbl_cellTitle setText:_entity.Name];
    
    [imgv_top setImageWithURL:_entity.Courses[randomIndex][@"Cover"] placeholderImage:nil];
    [lbl_top setText:_entity.Courses[randomIndex][@"Name"]];
    [lbl_top_count setText:
     [NSString stringWithFormat:@"已更新%@集", _entity.Courses[randomIndex][@"Period"]]];
    btn_top.tag = randomIndex;
    
    
//    imgv_top.layer.shadowColor = [UIColor blackColor].CGColor;
//    imgv_top.layer.shadowOffset = CGSizeMake(1, 1);
//    imgv_top.layer.shadowOpacity = 0.4;
//    imgv_top.layer.shadowRadius = 1;
    
    [imgv_line1left setImageWithURL:_entity.Courses[randomIndex + 1][@"Cover"] placeholderImage:nil];
    [lbl_line1left_title setText:_entity.Courses[randomIndex + 1][@"Name"]];
    [lbl_line1left_des setText:_entity.Courses[randomIndex + 1][@"Description"]];
    [lbl_line1left_count setText:
     [NSString stringWithFormat:@"更新%@集", _entity.Courses[randomIndex + 1][@"Period"]]];
    btn_line1left.tag = randomIndex + 1;
    
    [imgv_line1right setImageWithURL:_entity.Courses[randomIndex + 2][@"Cover"] placeholderImage:nil];
    [lbl_line1right_title setText:_entity.Courses[randomIndex + 2][@"Name"]];
    [lbl_line1right_des setText:_entity.Courses[randomIndex + 2][@"Description"]];
    [lbl_line1right_count setText:
     [NSString stringWithFormat:@"更新%@集", _entity.Courses[randomIndex + 2][@"Period"]]];
    btn_line1right.tag = randomIndex + 2;
    
    [imgv_line2left setImageWithURL:_entity.Courses[randomIndex + 3][@"Cover"] placeholderImage:nil];
    [lbl_line2left_title setText:_entity.Courses[randomIndex + 3][@"Name"]];
    [lbl_line2left_des setText:_entity.Courses[randomIndex + 3][@"Description"]];
    [lbl_line2left_count setText:
     [NSString stringWithFormat:@"更新%@集", _entity.Courses[randomIndex + 3][@"Period"]]];
    btn_line2left.tag = randomIndex + 3;
    
    [imgv_line2right setImageWithURL:_entity.Courses[randomIndex + 4][@"Cover"] placeholderImage:nil];
    [lbl_line2right_title setText:_entity.Courses[randomIndex + 4][@"Name"]];
    [lbl_line2right_des setText:_entity.Courses[randomIndex + 4][@"Description"]];
    [lbl_line2right_count setText:
     [NSString stringWithFormat:@"更新%@集", _entity.Courses[randomIndex + 4][@"Period"]]];
    btn_line2right.tag = randomIndex + 4;
    
    [imgv_line3left setImageWithURL:_entity.Courses[randomIndex + 5][@"Cover"] placeholderImage:nil];
    [lbl_line3left_title setText:_entity.Courses[randomIndex + 5][@"Name"]];
    [lbl_line3left_des setText:_entity.Courses[randomIndex + 5][@"Description"]];
    [lbl_line3left_count setText:
     [NSString stringWithFormat:@"更新%@集", _entity.Courses[randomIndex + 5][@"Period"]]];
    btn_line3left.tag = randomIndex + 5;
    
    
    [imgv_line3right setImageWithURL:_entity.Courses[randomIndex + 6][@"Cover"] placeholderImage:nil];
    [lbl_line3right_title setText:_entity.Courses[randomIndex + 6][@"Name"]];
    [lbl_line3right_des setText:_entity.Courses[randomIndex + 6][@"Description"]];
    [lbl_line3right_count setText:
     [NSString stringWithFormat:@"更新%@集", _entity.Courses[randomIndex + 6][@"Period"]]];
    btn_line3right.tag = randomIndex + 6;
}

- (IBAction) onMoreButtonClick:(id)sender {
    int index = 3;
    if([_entity.Name isEqualToString:@"老年大学"]) index = 4;
}

@end
