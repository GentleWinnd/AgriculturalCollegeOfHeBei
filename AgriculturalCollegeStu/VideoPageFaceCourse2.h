//
//  VideoPageFaceCourse2.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/18.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"
#import "VideoPageDetailView.h"
#import "FaceCourseModel.h"

@interface VideoPageFaceCourse2 : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UIView *v_topContainer;
@property (weak, nonatomic) IBOutlet UIView *v_buttomContainer;
@property (weak, nonatomic) IBOutlet UIView *v_buttomContainer_topv;
@property (weak, nonatomic) IBOutlet UITextView *textv_teacherDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_coursePic;
@property (weak, nonatomic) IBOutlet UILabel *lbl_topTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_centerDesc;



@property (weak, nonatomic) IBOutlet UIButton *btn_goback;

@property (strong, nonatomic) NSString *topTitle;
@property (strong, nonatomic) NSString *teacherDesc;
@property (strong, nonatomic) NSString *picUrl;
@property (strong, nonatomic) HOMEBaseViewController *parentVc;

- (IBAction) onGobackClicked:(id)sender;

@end