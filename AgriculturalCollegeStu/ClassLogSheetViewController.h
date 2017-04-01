//
//  ClassLogSheetViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ClassLogSheetViewController : BaseViewController

@property (assign, nonatomic) UserRole userRole;
@property (strong, nonatomic) NSMutableArray *courseInfoArray;

@end
