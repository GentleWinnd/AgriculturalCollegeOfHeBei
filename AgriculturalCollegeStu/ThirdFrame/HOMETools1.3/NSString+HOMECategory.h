//
//  NSString+HOMECategory.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/8/13.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
/** 以宽度作为基准 */
    HOMEFixationSize_Width =0,
/** 以高度作为基准 */
    HOMEFixationSize_Height,
} HOMEFixationSize;

@interface NSString (HOMECategory)

/** HOMETools:NSString+HOMECategory为NSString增加一个将汉字转换为拼音的类别 */
- (NSString *) transformToPinyin;
/** HOMETools:NSString+HOMECategory为NSString增加一个将NSTimeInterval转换为yyyy-MM-dd HH:mm:ss格式的类别 */
- (NSString *) HOMEDateSince1970;
/** HOMETools:NSString+HOMECategory为NSString增加一个将yyyy-MM-dd HH:mm:ss格式的时间转换为星期几的类别 */
- (NSString *) HOMEWeek;
/** HOMETools:NSString+HOMECategory为NSString增加一个将字符串转换为utf-8格式字符串的类别 */
- (NSString *) HOMEUtf8String;
/** HOMETools:NSString+HOMECategory为NSString增加一个将yyyy-MM-dd HH:mm:ss格式的时间字符串转换为NSDate类型的类别 */
- (NSDate *) HOMETransformToDate;
/** md5加密
 *32位小写 */
- (NSString *) MD5Base32String;
/** md5加密
 *16位小写 */
- (NSString *) MD5Base16String;
/** sha安全哈希加密
*sha1加密 */
- (NSString *) Sha1String;
/** sha安全哈希加密
*sha256加密 */
- (NSString *) Sha256String;
/** sha安全哈希加密
*sha384加密 */
- (NSString *) Sha384String;
/**sha安全哈希加密
*sha512加密 */
- (NSString *) Sha512String;

-(CGRect)HOMEStringSizeWithSize:(CGSize)size withFixationSize:(HOMEFixationSize)fixationSize withFon:(UIFont *)font;

@end
