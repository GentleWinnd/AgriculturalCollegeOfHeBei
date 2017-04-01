//
//  StuClassTestViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface StuClassTestViewController : BaseViewController

/**
 update testView
 */
@property (nonatomic, strong) NSDictionary *testInfo;
- (void)updateTestCourse;
@end
