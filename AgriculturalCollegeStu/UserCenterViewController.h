//
//  UserCenterViewController.h
//  OldUniversity
//
//  Created by mahaomeng on 15/7/23.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//

#import "HOMEBaseViewController.h"

typedef void(^UserCenterViewControllerFavoriteBlock)(void);

@interface UserCenterViewController : HOMEBaseViewController

@property (nonatomic, copy) UserCenterViewControllerFavoriteBlock favoriteBlock;

-(instancetype)initWithFlag:(BOOL)flag;

@end
