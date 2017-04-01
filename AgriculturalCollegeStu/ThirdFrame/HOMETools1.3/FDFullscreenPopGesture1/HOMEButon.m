//
//  HOMEButon.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/10.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "HOMEButon.h"
#import "HOMEHeader.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@implementation HOMEButon

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andButtonClickEvent:(OnButtonClick)event
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) myself = self;
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [self addTarget:myself action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _homeBlock0xx = event;
    }
    return self;
}

-(void)onButtonClick:(__weak HOMEButon *)sender
{
    WS(ws);
    ws.homeBlock0xx(ws);

}

@end
