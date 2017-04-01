//
//  FirstPageTitleTableViewCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/12.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FirstPageTitleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_pointer;

+ (instancetype) initViewLayout;

- (void) setTitleName:(NSString *) titleName;

@end