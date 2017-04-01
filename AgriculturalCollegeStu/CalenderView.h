//
//  CalenderView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawCircleView.h"
@class MonthModel;

@interface CalenderView : UIView
@property (strong, nonatomic) NSMutableArray *classArray;


@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;
@property (weak, nonatomic) DrawCircleView *circleView;
@property (strong, nonatomic) MonthModel *monthModel;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;
@end
