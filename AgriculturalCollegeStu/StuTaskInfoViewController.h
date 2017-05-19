//
//  StuTaskInfoViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StuTaskInfoViewController : BaseViewController

@property (assign, nonatomic) UserRole role;
@property (strong, nonatomic) NSDictionary *stuInfo;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *studentId;
@property (strong, nonatomic) NSString *ActivityId;

@end
