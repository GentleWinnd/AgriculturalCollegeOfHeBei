//
//  NSString+Attribute.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/9.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "NSString+Attribute.h"

@implementation NSString (Attribute)

//set attributeString

+ (NSMutableAttributedString *)attrStrFrom:(NSString *)allString colorStr:(NSString *)colorStr color:(UIColor *)color font:(UIFont *)font {
    if (allString == nil) {
        return nil;
    }
    NSMutableAttributedString *arrString = [[NSMutableAttributedString alloc]initWithString:allString];
    // 设置前面几个字串的格式:字号字体、颜色
    [arrString addAttributes:@{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:color
                               }
                       range:[allString rangeOfString:colorStr]];
    return arrString;
}

@end
