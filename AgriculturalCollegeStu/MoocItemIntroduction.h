//
//  MoocItemIntroduction.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/17.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SubTableViewModel.h"
#import "HOMEBaseViewController.h"
#import "OfflineCourseModel.h"

@interface MoocItemIntroduction : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *v_itemContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_itemCover;
@property (weak, nonatomic) IBOutlet UIScrollView *scl_itemDescContainer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_teacher;
@property (weak, nonatomic) IBOutlet UIView *v_avatarContainer;
@property (weak, nonatomic) IBOutlet UIButton *btn_toLearn;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_start;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_date;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_address;
@property (weak, nonatomic) IBOutlet UILabel *lbl_start;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address;
@property (weak, nonatomic) IBOutlet UILabel *lbl_teacher;
@property (weak, nonatomic) IBOutlet UILabel *lbl_unsignCount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_planCount;

@property (strong, nonatomic) HOMEBaseViewController *parentVController;
@property (strong, nonatomic) SubTableViewModel *entity;
@property (strong, nonatomic) OfflineCourseModel *entity2;
@property (strong, nonatomic) NSString *userName;


+ (instancetype) initViewLayout;

- (void) fillContent;

- (IBAction) toLearnAction:(id)sender;

@end