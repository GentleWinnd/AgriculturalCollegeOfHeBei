//
//  FocusSlidView2.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/29.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewCycModel.h"
#import "BaseTableViewCell.h"

@interface FocusSlidView2 : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UITableView *tabv_imgs;
@property (weak, nonatomic) IBOutlet UITableView *tabv_dots;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@property (strong, nonatomic) NSArray *cycModels;
@property (assign, nonatomic) int slidDelay;

- (void) setFocusImgsList:(NSMutableArray *) cycModels;

+ (instancetype) initViewLayout;

@end
