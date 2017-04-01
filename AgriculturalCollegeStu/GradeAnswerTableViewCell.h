//
//  GradeAnswerTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradeAnswerTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *questionNum;
@property (strong, nonatomic) IBOutlet UILabel *questionName;
@property (strong, nonatomic) IBOutlet UILabel *finishedState;
@property (strong, nonatomic) IBOutlet UILabel *gradelabel;
@property (strong, nonatomic) IBOutlet UILabel *MineAnswer;
@property (strong, nonatomic) IBOutlet UILabel *correctAnswer;

@end
