//
//  TestResultViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TestResultViewController : BaseViewController
@property (nonatomic, assign) UserRole *userRole;
@property (nonatomic, strong) NSArray *courseArray;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *courseName;

@end
