//
//  ChatTribeTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/2/27.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTribeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *goupNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *massageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
