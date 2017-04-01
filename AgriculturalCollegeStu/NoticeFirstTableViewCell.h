//
//  NoticeFirstTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeFirstTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *classGrade;
@property (strong, nonatomic) IBOutlet UILabel *cource;
@property (strong, nonatomic) IBOutlet UILabel *approvalReson;
@property (strong, nonatomic) IBOutlet UILabel *subState;

@end
