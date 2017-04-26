//
//  HOMELabel.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/14.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "HOMELabel.h"

@implementation HOMELabel

-(void)setText:(NSString *)text
{
    [super setText:text];
    CGRect frame = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 99999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ceil(frame.size.height));
    self.numberOfLines = 0;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    if (self.text.length != 0) {
        CGRect frame = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 99999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ceil(frame.size.height));
        self.numberOfLines = 0;
    }
}

@end
