//
//  SigninViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/9.
//  Copyright © 2016年 YH. All rights reserved.
//

@protocol SigninViewControllerDelegate <NSObject>

- (void)signResult:(BOOL)success;

@end

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SigninViewController : BaseViewController

@property (assign, nonatomic) UserRole userRole;
@property (assign, nonatomic) id<SigninViewControllerDelegate>deleage;

@end
