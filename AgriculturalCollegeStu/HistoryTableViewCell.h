//
//  HistoryTableViewCell.h
//  OldUniversity
//
//  Created by mahaomeng on 15/8/6.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMELabel.h"
#import "HOMEHeader.h"

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end
