//
//  HOMETools.h
//  HOMEStar
//
//  Created by mahaomeng on 15-4-21.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

        /**  */

/*
 ====================================================================================================//切换类型枚举
 */
typedef enum{
        /** 切换类型:淡入淡出 */
    AnimationTypeFade = 1,
        /** 切换类型:推挤 */
    AnimationTypePush,
        /** 切换类型:揭开 */
    AnimationTypeReveal,
        /** 切换类型:覆盖 */
    AnimationTypeMoveIn,
        /** 切换类型:立方体 */
    AnimationTypeCube,
        /** 切换类型:吮吸 */
    AnimationTypeSuckEffect,
        /** 切换类型:翻转 */
    AnimationTypeOglFlip,
        /** 切换类型:波纹 */
    AnimationTypeRippleEffect,
        /** 切换类型:翻页 */
    AnimationTypePageCurl,
        /** 切换类型:反翻页 */
    AnimationTypePageUnCurl,
        /** 切换类型:开镜头 */
    AnimationTypeCameraIrisHollowOpen,
        /** 切换类型:关镜头 */
    AnimationTypeCameraIrisHollowClose,
        /** 切换类型:下翻页 */
    AnimationTypeCurlDown,
        /** 切换类型:上翻页 */
    AnimationTypeCurlUp,
        /** 切换类型:左翻转 */
    AnimationTypeFlipFromLeft,
        /** 切换类型:右旋转 */
    AnimationTypeFlipFromRight,
} AnimationTypes;

/*
 ====================================================================================================//动画方向枚举
 */
typedef enum {
    /** 动画方向:动画从左边 */
    DirectionFromLeft = 1,
    /** 动画方向:动画从底部 */
    DirectionFromBottom,
    /** 动画方向:动画从右边 */
    DirectionFromRight,
    /** 动画方向:动画从头部 */
    DirectionFromTop,
} DirectionFrom;

/*
 ====================================================================================================//label字体对齐方式枚举
 */
typedef enum {
    AlignmentCenter =1,
    AlignmentJustified,
    AlignmentLeft,
    AlignmentNatural,
    AlignmentRight
} Alignment;

@interface HOMETools : NSObject

/** 为某个视图控制器切换添加动画效果 */
+(void)AnimationWithType:(AnimationTypes)animationType DirectionFrom:(DirectionFrom)direction addToView:(UIView *)view;

/** 创建Label */
+(void)LabelWithFrame:(CGRect)frame text:(NSString *)text font:(CGFloat)font alignment:(Alignment)alignment backgroundColor:(UIColor *)color addToView:(UIView *)labelSuperView;

@end
