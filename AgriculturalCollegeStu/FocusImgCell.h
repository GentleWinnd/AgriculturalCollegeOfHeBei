//
//  FocusImgCell.h
//  xingxue_pro
//
//  Created by 张磊 on 16/4/29.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface FocusImgCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgv;

- (void) setImageUrl:(NSString *) cover;

+ (instancetype) initViewLayout;

@end
