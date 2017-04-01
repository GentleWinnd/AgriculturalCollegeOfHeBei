//
//  FirstPageCellA.m
//  xingxue_pro
//
//  Created by 张磊 on 16/4/7.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FirstPageCellA.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "VideoPageController.h"

@interface FirstPageCellA ()

@end

@implementation FirstPageCellA

@synthesize topLayoutContainer;
@synthesize btmLayoutContainer;

@synthesize view_btm_center_item_container = _view_btm_center_item_container;
@synthesize view_btm_left_item_container = _view_btm_left_item_container;
@synthesize view_btm_right_item_container = _view_btm_right_item_container;

@synthesize btn_ToMore = _btn_ToMore;
@synthesize lbl_CellTitle = _lbl_CellTitle;

@synthesize img_leftPic = _img_leftPic;
@synthesize img_CenterPic = _img_CenterPic;
@synthesize img_RightPic = _img_RightPic;

@synthesize btn_leftItem = _btn_leftItem;
@synthesize btn_RightItem = _btn_RightItem;
@synthesize btn_CenterItem = _btn_CenterItem;

@synthesize lbl_leftTitle = _lbl_leftTitle;
@synthesize lbl_rightTitle = _lbl_rightTitle;
@synthesize lbl_centerTitle = _lbl_centerTitle;

@synthesize lbl_centerDes = _lbl_centerDes;
@synthesize lbl_leftDes = _lbl_leftDes;
@synthesize lbl_rightDes = _lbl_rightDes;

@synthesize entity = _entity;


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
     NSLog(@"load layout for FirstPage cell A");
    [self setUserInteractionEnabled:YES];
    [topLayoutContainer setUserInteractionEnabled:YES];
    [btmLayoutContainer setUserInteractionEnabled:YES];
    
    _lbl_CellTitle.font = [UIFont fontWithName:@"Microsoft Yahei" size:15];
    
    [self bringSubviewToFront:topLayoutContainer];// *重要*
    [self bringSubviewToFront:btmLayoutContainer];// *重要* 去掉按钮将会无法响应点击事件
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self) {
        
    }
    return self;
}

- (IBAction) onMoreButtonClick:(id)sender {
    [super onMoreButtonClick:sender];
}

- (IBAction) onButtonClick:(id)sender {
    
    NSString *courseId = nil;
    NSString *pageCategoryId = nil;
    NSString *courseCover = nil;
    
    courseId = _entity.Courses[[sender tag]][@"Id"];
    courseCover = _entity.Courses[[sender tag]][@"Cover"];
    pageCategoryId = _entity.Id;
    
    [self pushToVideoPage:courseId courseCover:courseCover pageCategoryId:pageCategoryId];
    
}

+ (instancetype) initViewLayout {
    
    FirstPageCellA *cell = [[[NSBundle mainBundle] loadNibNamed:@"first_page_cell_1" owner:nil options:nil]  lastObject];
    
    return cell;
}

- (void) fillContent {
    
    [_lbl_CellTitle setText:_entity.Name];
    
    int randomIndex = self.randomValue;
    if(randomIndex >= _entity.Courses.count || randomIndex + 2 >= _entity.Courses.count) {
        randomIndex = (int) _entity.Courses.count - 3;
    }
    
    for(int i = randomIndex; i < randomIndex + 3/*_entity.Courses.count*/; i ++) {
        NSURL *imgCover = _entity.Courses[i][@"Cover"];
        NSString *title = _entity.Courses[i][@"Name"];
        NSString *desc  = _entity.Courses[i][@"Description"];
        NSLog(@"first cell img url : %@", imgCover);
        if(i == randomIndex) {
//            [_btn_leftItem setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:_entity.Courses[i][@"Cover"]] placeholderImage:[UIImage imageNamed:@"default"]];
//            _view_btm_left_item_container.layer.shadowColor = [UIColor blackColor].CGColor;
//            _view_btm_left_item_container.layer.shadowOffset = CGSizeMake(1, 1);
//            _view_btm_left_item_container.layer.shadowOpacity = 0.4;
//            _view_btm_left_item_container.layer.shadowRadius = 1;
            
            _btn_leftItem.tag = randomIndex;
            
            [_img_leftPic setImageWithURL:imgCover];
            _img_leftPic.contentMode = UIViewContentModeScaleAspectFill;
            
            [_lbl_leftTitle setText:title];
            [_lbl_leftDes setText:desc];
            
        } else if (i == randomIndex + 1) {
//            _view_btm_center_item_container.layer.shadowColor = [UIColor blackColor].CGColor;
//            _view_btm_center_item_container.layer.shadowOffset = CGSizeMake(1, 1);
//            _view_btm_center_item_container.layer.shadowOpacity = 0.4;
//            _view_btm_center_item_container.layer.shadowRadius = 1;
            
            _btn_CenterItem.tag = randomIndex + 1;
            
            [_img_CenterPic setImageWithURL:imgCover];
            _img_CenterPic.contentMode = UIViewContentModeScaleAspectFill;
            
            [_lbl_centerTitle setText:title];
            [_lbl_centerDes setText:desc];
            
        } else if(i == randomIndex + 2) {
//            _view_btm_right_item_container.layer.shadowColor = [UIColor blackColor].CGColor;
//            _view_btm_right_item_container.layer.shadowOffset = CGSizeMake(1, 1);
//            _view_btm_right_item_container.layer.shadowOpacity = 0.4;
//            _view_btm_right_item_container.layer.shadowRadius = 1;
            
            _btn_RightItem.tag = randomIndex + 2;
            
            [_img_RightPic setImageWithURL:imgCover];
            _img_RightPic.contentMode = UIViewContentModeScaleAspectFill;
            
            [_lbl_rightTitle setText:title];
            [_lbl_rightDes setText:desc];
        }
        
        imgCover = nil;
        title = nil;
        desc = nil;
    }
    
}

@end
