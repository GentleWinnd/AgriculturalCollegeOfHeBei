//
//  HOMETools.m
//  HOMEStar
//
//  Created by mahaomeng on 15-4-21.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import "HOMETools.h"

@implementation HOMETools

+(void)AnimationWithType:(AnimationTypes)animationType DirectionFrom:(DirectionFrom)direction addToView:(UIView *)view
{
    NSString *str;
    switch (animationType) {
        case AnimationTypeFade:
            str = @"fade";
            break;
        case AnimationTypePush:
        str = @"push";
        break;
        case AnimationTypeReveal:
            str = @"reveal";
            break;
        case AnimationTypeMoveIn:
            str = @"moveIn";
            break;
        case AnimationTypeCube:
            str = @"cube";
            break;
        case AnimationTypeSuckEffect:
            str = @"suckEffect";
            break;
        case AnimationTypeOglFlip:
            str = @"oglFlip";
            break;
        case AnimationTypeRippleEffect:
            str = @"rippleEffect";
            break;
        case AnimationTypePageCurl:
            str = @"pageCurl";
            break;
        case AnimationTypePageUnCurl:
            str = @"pageUnCurl";
            break;
        case AnimationTypeCameraIrisHollowClose:
            str = @"cameraIrisHollowClose";
            break;
        case AnimationTypeCameraIrisHollowOpen:
            str = @"cameraIrisHollowOpen";
            break;
        case AnimationTypeCurlDown:
            str = @"curlDown";
            break;
        case AnimationTypeCurlUp:
            str = @"curlUp";
            break;
        case AnimationTypeFlipFromLeft:
            str = @"flipFromLeft";
            break;
        default:
            str = @"flipFromRight";
            break;
    }
    
    NSString *fromDirection;
    switch (direction) {
        case DirectionFromLeft:
            fromDirection = kCATransitionFromLeft;
            break;
        case DirectionFromBottom:
            fromDirection = kCATransitionFromBottom;
            break;
        case DirectionFromRight:
            fromDirection = kCATransitionFromRight;
            break;

        default:
            fromDirection = kCATransitionFromTop;
            break;
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0f;
    animation.type = str;
    animation.subtype = fromDirection;
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:nil];
}

+(void)LabelWithFrame:(CGRect)frame text:(NSString *)text font:(CGFloat)font alignment:(Alignment)alignment backgroundColor:(UIColor *)color addToView:(UIView *)labelSuperView
{

    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    if (color) {
        label.backgroundColor = color;
    }
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    
    switch (alignment) {
        case AlignmentCenter:
            label.textAlignment = NSTextAlignmentCenter;
            break;
        case AlignmentLeft:
            label.textAlignment = NSTextAlignmentLeft;
            break;
        case AlignmentRight:
            label.textAlignment = NSTextAlignmentRight;
            break;
        case AlignmentJustified:
            label.textAlignment = NSTextAlignmentJustified;
            break;
        default:
            label.textAlignment = NSTextAlignmentNatural;
            break;
    }

    [labelSuperView addSubview:label];
}


@end
