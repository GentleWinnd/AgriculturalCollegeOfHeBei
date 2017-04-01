//
//  UIColor+homecate.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/11.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (homecate)

/** HOMETools:UIColor+homecate增加16进制色值
 <说明:色值要用NSString类型 例如:@"#FFD700" @"0xFFD700"> */
+(UIColor *)colorWithHexValue:(NSString *)hexValue;

@end
