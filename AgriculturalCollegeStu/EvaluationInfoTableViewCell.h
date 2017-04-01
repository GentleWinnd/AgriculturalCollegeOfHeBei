//
//  EvaluationInfoTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerPortriat;
@property (strong, nonatomic) IBOutlet UILabel *stuName;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *evaluationInfo;

@end
