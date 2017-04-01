//
//  HOMEButon.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/10.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HOMEButon;

typedef  void (^OnButtonClick)(__weak HOMEButon *sender);

@interface HOMEButon : UIButton

@property (nonatomic, copy) OnButtonClick homeBlock0xx;

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andButtonClickEvent:(OnButtonClick)event;

@end
