//
//  HOMEEdgeView.m
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/14.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import "HOMEEdgeView.h"
#import "HOMETools.h"

@implementation HOMEEdgeView
{
//    UIView *_superView0xxx;
    UIViewController *_superViewController0xxx;
    CGFloat _myEdgeWidth0xxx;
}

-(instancetype)initWithWidth:(CGFloat)edgeWidth withViewController:(UIViewController *)superViewController
{
    CGFloat myY;
    if (superViewController.navigationController) {
        myY = superViewController.navigationController.navigationBar.frame.origin.y +superViewController.navigationController.navigationBar.frame.size.height;
    } else {
        myY = 0.f;
    }
    self = [super initWithFrame:CGRectMake(0 -edgeWidth, myY, edgeWidth, superViewController.view.bounds.size.height -myY)];
    if (self) {
        _myEdgeWidth0xxx = edgeWidth;
        _superViewController0xxx = superViewController;
        self.hidden = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

-(instancetype)initWithWidth:(CGFloat)edgeWidth withView:(UIView *)superView
{
    self = [super init];
    if (self) {
//        并不知道怎么写
    }
    return self;
}

-(void)showEdgeView
{
    __weak typeof(self) myself0xxx = self;
    if (self.frame.origin.x == 0 -_myEdgeWidth0xxx) {
        self.hidden = NO;
        [UIView animateWithDuration:0.8f animations:^{
            [HOMETools AnimationWithType:AnimationTypePush DirectionFrom:DirectionFromLeft addToView:myself0xxx];
            for (UIView *view0xxx in _superViewController0xxx.view.subviews) {
                CGPoint point = view0xxx.center;
                point.x += _myEdgeWidth0xxx;
                view0xxx.center = point;
            }
        }];
    }
}

-(void)hiddenEdgeView
{
    __weak typeof(self) myself0xxx = self;
    if (self.frame.origin.x == 0) {
        [UIView animateWithDuration:0.8f animations:^{

            [HOMETools AnimationWithType:AnimationTypePush DirectionFrom:DirectionFromRight addToView:myself0xxx];
            for (UIView *view0xxx in _superViewController0xxx.view.subviews) {
                CGPoint point = view0xxx.center;
                point.x -= _myEdgeWidth0xxx;
                view0xxx.center = point;
            }
        }completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    CGFloat flag = 0;
    for (UIView *subView in self.subviews) {
        if (flag <= subView.frame.size.height +subView.frame.origin.y) {
            flag = subView.frame.size.height +subView.frame.origin.y;
        }
    }
    self.contentSize = CGSizeMake(0, flag);
}

@end
