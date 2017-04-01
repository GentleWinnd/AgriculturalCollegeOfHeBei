//
//  SetNavigationItem.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//
typedef void(^leftBtnClick)();
typedef void(^rightBtnClick)();
typedef void(^titleClick)();

#import <Foundation/Foundation.h>

@interface SetNavigationItem : NSObject

@property (strong, nonatomic) leftBtnClick leftClick;

@property (strong, nonatomic) rightBtnClick rightClick;

@property (strong, nonatomic) titleClick titleClick;

+ (instancetype)shareSetNavManager;


/**
 设置导航栏title

 @param VC 设置目标的VC
 @param title 显示文字
 @param STitle 需要自定义的文字
 */
- (void)setNavTitle:(UIViewController *)VC withTitle:(NSString *)title subTitle:(NSString *)STitle;


/**
 设置导航栏的右边的按钮

 @param VC 目标的VC
 @param title 显示的文字
 @param color 现实的颜色
 */
- (void)setNavRightItem:(UIViewController *)VC withItemTitle:(NSString *)title textColor:(UIColor *)color;

- (void)setNavRightItem:(UIViewController *)VC withCustomView:(UIButton *)rightBtn;


/**
 设置导航栏左边的按钮

 @param VC 目标的VC
 @param title 显示的文字
 @param image 现实的颜色
 */
- (void)setNavLeftItem:(UIViewController *)VC withItemTitle:(NSString *)title image:(UIImage  *)image;

- (void)setNavLeftItem:(UIViewController *)VC withCustomView:(UIButton *)leftBtn;


/**
 customNaivigationBar
 */
- (void)customGlobleNavigationBarStyle;

@end
