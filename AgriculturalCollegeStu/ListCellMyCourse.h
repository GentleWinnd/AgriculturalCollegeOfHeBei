//
//  ListCellMyCourse.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/19.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPageModel.h"
#import "BaseTableViewCell.h"
#import "OfflineCourseModel.h"
#import "HOMEBaseViewController.h"

@interface ListCellMyCourse : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv_pic;
@property (weak, nonatomic) IBOutlet UILabel *lbl_startDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_teacherName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancelSign;

@property (strong, nonatomic) HOMEBaseViewController *parentVc;
@property (strong, nonatomic) OfflineCourseModel *entity;

+ (instancetype) initViewLayout;

- (void) fillContent:(OfflineCourseModel *) model;

- (IBAction) onCancelBtnClick:(id)sender;

@end
