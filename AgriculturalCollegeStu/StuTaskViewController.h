//
//  StuTaskViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/21.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface StuTaskViewController : BaseViewController<UITextViewDelegate>

@property (assign, nonatomic) UserRole userRole;

@end
