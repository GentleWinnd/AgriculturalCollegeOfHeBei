//
//  DownloadTableViewCell.h
//  OldUniversity
//
//  Created by mahaomeng on 15/8/7.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMELabel.h"
#import "UIImageView+WebCache.h"

@interface DownloadTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, retain) NSDictionary *videoInfo;

@end
