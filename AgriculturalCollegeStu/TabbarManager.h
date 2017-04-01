//
//  TabbarManager.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/14.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface TabbarManager : NSObject

/**
 * hidden tabbar
 @param hidden YES Or NO
 */
+ (void)setTabBarHidden:(BOOL)hidden;

/**
 * set selected tabbar
 @param selectedIndex is tababar index
 */
+ (void)setSelectedIndex:(NSUInteger)selectedIndex;


@end
