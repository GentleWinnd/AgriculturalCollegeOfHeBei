//
//  HOMEEdgeView.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/14.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

/** HOMETools:HOMEEdgeView为已有的视图添加抽屉 */
@interface HOMEEdgeView : UIScrollView

/** HOMETools:HOMEEdgeView的初始化方法
 <参数1:抽屉的宽度>
 <参数2:需要添加抽屉的视图控制器>
 <备注1:调用addSubview将控件添加到edgeView上>
 <备注2:抽屉出现方法:showEdgeView 抽屉隐藏方法:hiddenEdgeView>
 ！！！重写addSubview714*/
-(instancetype)initWithWidth:(CGFloat)edgeWidth withViewController:(UIViewController *)superViewController;

//技术不成熟,并未暴露
//-(instancetype)initWithWidth:(CGFloat)edgeWidth withView:(UIView *)superView;

/** HOMETools:HOMEEdgeView抽屉出现方法 */
-(void)showEdgeView;

/** HOMETools:HOMEEdgeView抽屉隐藏方法 */
-(void)hiddenEdgeView;

@end
