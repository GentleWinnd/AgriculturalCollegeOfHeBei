//
//  ChapterSuperCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/10.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"
#import "BaseTableViewCell.h"
#import "FaceCourseModel.h"
#import "VideoView.h"

#define TAG_0  0xB7A1
#define TAG_1  0x2C5D

@interface ChapterSuperCell : BaseTableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabv_chapterInfo;

@property (strong, nonatomic) FaceCourseModel *entity;
@property (strong, nonatomic) VideoView *videoView;
@property (strong, nonatomic) HOMEBaseViewController *parentVc;


- (void) processChapterInfo;

+ (instancetype) initViewLayout;

@end
