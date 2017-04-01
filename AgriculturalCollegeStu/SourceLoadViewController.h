//
//  SourceLoadViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SourceLoadViewController : BaseViewController
@property (nonatomic, assign) UserRole userRole;

@property (nonatomic, strong) NSMutableArray *sourceArray;
@end
