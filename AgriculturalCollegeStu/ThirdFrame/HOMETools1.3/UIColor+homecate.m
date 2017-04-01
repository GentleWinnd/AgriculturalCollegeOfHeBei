//
//  UIColor+homecate.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/11.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "UIColor+homecate.h"
#import "HOMEHeader.h"
@implementation UIColor (homecate)

+(UIColor *)colorWithHexValue:(NSString *)hexValue
{
    UIColor *color;
    NSMutableString *str = [[NSMutableString alloc]initWithString:hexValue];
    if ([str hasPrefix:@"#"]) {
        [str replaceCharactersInRange:NSMakeRange(0, 1) withString:@"0x"];
        unsigned long red = strtoul([str UTF8String], 0, 0);
        color = [[UIColor alloc]initWithRed:((float)(((red) & 0xFF0000) >> 16))/255.0 green:((float)(((red) & 0xFF00) >> 8))/255.0 blue:((float)((red) & 0xFF))/255.0 alpha:1.0];
    } else if ([str hasPrefix:@"0x"]) {
        unsigned long red = strtoul([str UTF8String], 0, 0);
        color = [[UIColor alloc]initWithRed:((float)(((red) & 0xFF0000) >> 16))/255.0 green:((float)(((red) & 0xFF00) >> 8))/255.0 blue:((float)((red) & 0xFF))/255.0 alpha:1.0];
    } else {
        color = [[UIColor alloc]initWithRed:((float)(((0xFF0000) & 0xFF0000) >> 16))/255.0 green:((float)(((0xFF0000) & 0xFF00) >> 8))/255.0 blue:((float)((0xFF0000) & 0xFF))/255.0 alpha:1.0];
        NSLog(@"HOMETools_error:16进制色值格式有误,使用默认颜色0xFF0000");
    }
    return color;
}

@end