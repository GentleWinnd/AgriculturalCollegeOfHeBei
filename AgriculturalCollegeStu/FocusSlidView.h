//
//  FocusSlidView.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/1.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"
#import "MainViewCycModel.h"
#import "BaseTableViewCell.h"

@interface FocusSlidView : BaseTableViewCell

@property (weak, nonatomic) SliderView *mainView;

@property (strong, nonatomic) MainViewCycModel *entity;
@property (strong, nonatomic) NSMutableArray *list;

+ (instancetype) initViewLayout;

- (void) fillLayout;

@end