//
//  VideoPageFaceCourse.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/9.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"
#import "VideoPageDetailView.h"
#import "VideoView.h"
#import "TeacherModel.h"
#import "FaceCourseModel.h"

@interface VideoPageFaceCourse : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UIView *v_topContainer;
@property (weak, nonatomic) IBOutlet UIView *v_buttomContainer;
@property (weak, nonatomic) IBOutlet UIView *v_buttomContainer_topv;

@property (weak, nonatomic) IBOutlet UIView *v_indactorChatperContainer;
@property (weak, nonatomic) IBOutlet UIView *v_indactorIntroducationContainer;

@property (weak, nonatomic) IBOutlet UIView *v_indactorChatperLine;
@property (weak, nonatomic) IBOutlet UIView *v_indactorIntroducationLine;

@property (weak, nonatomic) IBOutlet UITableView *tabv_mainContentTabview;

@property (weak, nonatomic) IBOutlet UIButton *btn_goback;
@property (weak, nonatomic) IBOutlet UIButton *btn_chapter;
@property (weak, nonatomic) IBOutlet UIButton *btn_introducation;

@property (strong, nonatomic) NSString *courseDesc;
@property (strong, nonatomic) TeacherModel *teacherModel;
@property (strong, nonatomic) HOMEBaseViewController *parentVc;

- (IBAction) onGobackClicked:(id)sender;

- (IBAction) onPageclick:(id)sender;

@end
