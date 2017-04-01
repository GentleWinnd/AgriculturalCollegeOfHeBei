//
//  TabbarManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "TabbarManager.h"

@implementation TabbarManager

+ (void)setTabBarHidden:(BOOL)hidden {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.viewController.tabBarHidden = hidden;
}

+ (void)setSelectedIndex:(NSUInteger)selectedIndex {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.viewController.selectedIndex = selectedIndex;
}


@end
