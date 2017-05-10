//
//  TestGradeViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestGradeViewController : UIViewController
@property (assign, nonatomic) UserRole role;
@property (copy, nonatomic) NSString *timeStr;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *studentId;

@end
