//
//  NSString+Attribute.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/9.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Attribute)
/**
 *  @brief  关键字高亮的处理
 *  @category
 *  @param  allString            整体字符串
 *  @param  colorStr            要改变颜色的字符串
 *  @param  color               要设置的颜色
 *  @param  font               字号
 **/
+ (NSMutableAttributedString *)attrStrFrom:(NSString *)allString colorStr:(NSString *)colorStr color:(UIColor *)color font:(UIFont *)font;

@end
