//
//  NSString+PinyinCategory.m
//  HOMETickets
//
//  Created by mahaomeng on 15/7/17.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "NSString+PinyinCategory.h"

@implementation NSString (PinyinCategory)

- (NSString *)transformToPinyin
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

@end
