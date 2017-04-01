//
//  DrawCircleView.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/12.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "DrawCircleView.h"

@implementation DrawCircleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.drawPicture == NO && _halfCircle==NO && _grayCircle==NO) {
        return;
    }
    CGFloat endAngle = _halfCircle?0:M_PI;
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.grayCircle) {
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, RulesLineColor_LightGray
                                         .CGColor);
        
        CGContextMoveToPoint(context, 35, 25);
        CGContextAddArc(context, 25, 25, 15, -M_PI, endAngle, 0);
        CGContextAddLineToPoint(context, 35,25);
        
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, RulesLineColor_LightGray.CGColor);//填充颜色
        CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
        return;
    }
    
    //弧线的是通过指定两个切点，还有角度，调用CGContextAddArcToPoint()绘制
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, MainDateColor_Green.CGColor);
    
    CGContextMoveToPoint(context, 35, 25);
    CGContextAddArc(context, 25, 25, 15, -M_PI, endAngle, 0);
    CGContextAddLineToPoint(context, 35,25);
    
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, MainDateColor_Green.CGColor);//填充颜色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
    
    if (!_halfCircle) {
        return;
    }

    CGContextSetStrokeColorWithColor(context,MainDateColor_Purple.CGColor);
    CGContextMoveToPoint(context, 35, 25);
    CGContextAddArc(context, 25, 25, 15, -M_PI, 0, 1);
    CGContextAddLineToPoint(context, 35,25);
    
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, MainDateColor_Purple.CGColor);//填充颜色
    //设置显示
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
}







@end
