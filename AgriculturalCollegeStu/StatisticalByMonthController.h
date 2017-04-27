//
//  StatisticalByMonthController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/11.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticalByMonthController : UIViewController

@property (nonatomic ,strong) NSString *statisticalID;
@property (nonatomic ,strong) NSString *studentID;


@end


@interface StatisticalMonthHeaderView : UIView

@property (nonatomic , strong) UILabel *timeLabel;

@end
