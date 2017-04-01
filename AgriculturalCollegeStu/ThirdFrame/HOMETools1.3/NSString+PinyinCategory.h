//
//  NSString+PinyinCategory.h
//  HOMETickets
//
//  Created by mahaomeng on 15/7/17.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinyinCategory)

/** HOMETools:NSString+PinyinCategory为NSString增加一个将汉字转换为拼音的类别 */
- (NSString *)transformToPinyin;

@end
