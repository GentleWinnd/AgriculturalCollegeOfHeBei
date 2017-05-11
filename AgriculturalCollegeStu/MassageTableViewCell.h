//
//  MassageTableViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/8.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^classScheduleClick)(UIButton *clickBtn);

@interface MassageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *massageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

@property (copy, nonatomic) classScheduleClick classSchedule;
@property (copy, nonatomic) void(^reloadCurrentClass)();


@end
