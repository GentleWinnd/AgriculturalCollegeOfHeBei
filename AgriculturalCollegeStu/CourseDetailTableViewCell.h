//
//  CourseDetailTableViewCell.h
//  OldUniversity
//
//  Created by mahaomeng on 15/8/4.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEHeader.h"
#import "HOMEBaseViewController.h"

@interface CourseDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) HOMELabel *lecturerLabel;
@property (nonatomic, strong) UILabel *periodLabel;

@end
