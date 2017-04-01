//
//  ChapterCellB.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseTableViewCell.h"
#import "ChapterSuperCell.h"

@interface ChapterCellB : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_left;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_right;

@property (weak, nonatomic) IBOutlet UIButton *btn_toPlayVideo;
@property (weak, nonatomic) IBOutlet UIButton *btn_toShowHandout;

@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSString *handoutContent;

@property (strong, nonatomic) ChapterSuperCell *hostCell;


+ (instancetype) initViewLayout;

- (IBAction)onSomeButtonClick:(id)sender;

@end