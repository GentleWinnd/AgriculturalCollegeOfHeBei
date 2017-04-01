//
//  SignedViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/10.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignedViewController : BaseViewController
@property (strong, nonatomic) NSDictionary *signedStuInfo;

@property (nonatomic, assign) BOOL isTribe;

@end
