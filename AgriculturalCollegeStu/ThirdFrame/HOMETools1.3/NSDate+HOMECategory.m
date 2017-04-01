//
//  NSDate+HOMECategory.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/8/13.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "NSDate+HOMECategory.h"

@implementation NSDate (HOMECategory)

-(NSString *)HOMETransformToString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}

@end
