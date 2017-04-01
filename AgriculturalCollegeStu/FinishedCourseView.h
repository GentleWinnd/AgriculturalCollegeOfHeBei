//
//  FinishedCourseView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^selectedCourseNum)(NSInteger num);

#import <UIKit/UIKit.h>

@interface FinishedCourseView : UIView
@property (strong, nonatomic) IBOutlet UIButton *courseBtn;
@property (strong, nonatomic) IBOutlet UIView *tapView;

@property (assign, nonatomic) NSInteger courseNumber;
@property (assign, nonatomic) NSInteger finishedNum;
@property (copy, nonatomic) selectedCourseNum selectedNum;
@property (strong, nonatomic) NSArray *finishedArray;


@end
