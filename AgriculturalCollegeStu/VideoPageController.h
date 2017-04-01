//
//  VideoPage.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/21.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"
#import "VideoPageDetailView.h"
#import "VideoView.h"

@interface VideoPageController : HOMEBaseViewController

@property (weak, nonatomic) IBOutlet UIView *v_videoContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *v_detailContainer;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UIButton *btn_playVideo;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_videoPlayIcon;
//@property (weak, nonatomic) IBOutlet VideoView *videoView;
@property (weak, nonatomic) IBOutlet UIView *coverLayer;
@property (weak, nonatomic) IBOutlet UIButton *coverLayerBoring;

@property (strong, nonatomic) UIViewController *parentVc;
@property (strong, nonatomic) VideoPageDetailView *v_detail;

@property (retain, nonatomic) NSString *courseId;
@property (retain, nonatomic) NSString *pageCategoryId;
@property (retain, nonatomic) NSString *courseCover;

@property (assign, nonatomic) BOOL isFromCache;
@property (retain, nonatomic) VideoPageModel *pageModel;

- (IBAction) onBackClick:(id)sender;

- (void)loadDetailInfo;

@end
