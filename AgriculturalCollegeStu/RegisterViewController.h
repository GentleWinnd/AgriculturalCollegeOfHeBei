//
//  RegisterViewController.h
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HOMEBaseViewController.h"

typedef void(^SendValue)(NSDictionary *userInfo);

@interface RegisterViewController : HOMEBaseViewController

@property (nonatomic, copy) SendValue valueBlock;

@end
