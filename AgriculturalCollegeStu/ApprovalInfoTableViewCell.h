//
//  ApprovalInfoTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^approvalResult)(BOOL greement);

#import <UIKit/UIKit.h>

@interface ApprovalInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (strong, nonatomic) IBOutlet UILabel *stuName;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *approvalReson;
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UILabel *approveState;



@property (copy, nonatomic) approvalResult approvalResult;

@end
