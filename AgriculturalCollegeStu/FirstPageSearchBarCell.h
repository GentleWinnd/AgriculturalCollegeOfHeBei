//
//  FirstPageSearchBarCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface FirstPageSearchBarCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn_searchBar;

+ (instancetype) initViewLayout;

- (IBAction) onSearchClick:(id)sender;

@end