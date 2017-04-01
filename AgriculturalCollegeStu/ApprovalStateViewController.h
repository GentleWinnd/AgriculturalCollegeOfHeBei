//
//  ApprovalStateViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ApprovalStateViewController : BaseViewController

@property (assign, nonatomic) UserRole userRole;
@property (strong, nonatomic) NSDictionary *approvalInfo;
@property (copy, nonatomic) NSString *approvalId;
@property (assign, nonatomic) BOOL approvalState;
@property (assign, nonatomic) BOOL backMain;

@end
