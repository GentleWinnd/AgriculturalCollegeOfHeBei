//
//  ChapterSuperCellB.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"
#import "BaseTableViewCell.h"
#import "FaceCourseModel.h"
#import "TeacherModel.h"

@interface ChapterSuperCellB : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_avatar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_info;
@property (weak, nonatomic) IBOutlet UIScrollView *scl_courseDesc;

@property (strong, nonatomic) TeacherModel *teacherModel;
@property (strong, nonatomic) NSString *courseDesc;


+ (instancetype) initViewLayout;

- (void) fillContent;

@end