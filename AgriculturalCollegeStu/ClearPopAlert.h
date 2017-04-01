//
//  ClearPopAlert.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/26.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPageModel.h"

@interface ClearPopAlert : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbl_messsage;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;
@property (weak, nonatomic) IBOutlet UIButton *btn_negtive;
@property (weak, nonatomic) IBOutlet UIView *v_btn_container;


+ (instancetype) initViewLayout;

- (IBAction) onClickEvetn:(id)sender;


@end
