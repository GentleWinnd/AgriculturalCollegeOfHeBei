//
//  MyInfoViewController.h
//  OldUniversity
//
//  Created by mahaomeng on 15/7/31.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HOMEBaseViewController.h"

typedef void(^MyInfoViewControllerBlock)(void);

@interface MyInfoViewController : HOMEBaseViewController

@property (nonatomic, retain) NSDictionary *subUserInfo;

@property (nonatomic, copy) MyInfoViewControllerBlock backBlock;

@end
