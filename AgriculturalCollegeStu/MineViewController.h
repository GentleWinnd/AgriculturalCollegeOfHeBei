//
//  MineViewController.h
//  xingxue_pro
//
//  Created by YH on 16/4/25.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMEBaseViewController.h"

@interface MineViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scl_contentContainer;

- (void) checkLoginInfo;

@end