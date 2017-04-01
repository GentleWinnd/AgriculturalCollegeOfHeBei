//
//  GroupTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerPortrait;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineLeadingSpace;

@end
