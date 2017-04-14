//
//  StatisticalStuInfoTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalStuInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
//
@property (strong, nonatomic) IBOutlet UILabel *leavelNum;
@property (strong, nonatomic) IBOutlet UILabel *signNum;
@property (strong, nonatomic) IBOutlet UILabel *questionNum;
//
@property (strong, nonatomic) IBOutlet UIView *backView1;
@property (strong, nonatomic) IBOutlet UIView *backView2;
@property (strong, nonatomic) IBOutlet UIView *backView3;

@end
