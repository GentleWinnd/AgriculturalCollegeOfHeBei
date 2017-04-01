//
//  NoticeTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallTitle;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
