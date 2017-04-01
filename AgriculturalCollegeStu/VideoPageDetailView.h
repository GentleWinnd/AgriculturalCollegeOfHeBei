//
//  VideoPageDetailView.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/21.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPageModel.h"
#import "VideoView.h"


@interface VideoPageDetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_desc;
@property (weak, nonatomic) IBOutlet UILabel *lbl_otherInfo1;
@property (weak, nonatomic) IBOutlet UITableView *tabv_episodes;
@property (weak, nonatomic) IBOutlet UITableView *tabv_recommend;

@property (weak, nonatomic) IBOutlet UIButton *btn_favorite;
@property (weak, nonatomic) IBOutlet UIButton *btn_share;

@property (strong, nonatomic) UIViewController *parentViewCnl;

@property (strong, nonatomic) VideoPageModel *entity;
@property (strong, nonatomic) VideoView *videoPlayer;

+ (instancetype) initViewLayout;

- (void) fillContent:(VideoView *) videoPlayer videoModel:(VideoPageModel *) model;

- (IBAction) favoriteClick:(id)sender;

@end
