//
//  SelecteCalenderView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/22.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selecteDate) (NSString *dateStr);

@interface SelecteCalenderView : UIView


@property (copy, nonatomic) selecteDate currentDate;


+ (instancetype)initLayoutview;

@end

@interface contentCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLabel;

@end
