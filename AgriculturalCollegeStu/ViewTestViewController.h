//
//  ViewTestViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ViewTestViewController : BaseViewController

@property (assign, nonatomic) ClassAssignmentType assignmentType;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;

@end
