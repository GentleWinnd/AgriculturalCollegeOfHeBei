//
//  SetNavigationItem.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/15.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "SetNavigationItem.h"
#import "NSString+Attribute.h"

@implementation SetNavigationItem

- (instancetype)init {
    self = [super init];
    if (self) {

    
    }
    return self;
}

+ (instancetype)shareSetNavManager {
    
    SetNavigationItem *setNav = [[SetNavigationItem alloc] init];
    return setNav;
}

#pragma Mark - 设置title

- (void)setNavTitle:(UIViewController *)VC withTitle:(NSString *)title subTitle:(NSString *)STitle {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    [titleLabel setAttributedText: [NSString attrStrFrom:title colorStr:STitle color:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]]];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserRole)];
    [titleLabel addGestureRecognizer:tap];
    VC.navigationItem.titleView = titleLabel;
    VC.navigationItem.titleView.userInteractionEnabled = YES;
    
}

- (void)changeUserRole {
    self.titleClick();
}

#pragma Mark - 设置左边的按钮

- (void)setNavLeftItem:(UIViewController *)VC withItemTitle:(NSString *)title image:(UIImage  *)image {
    UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBtn.frame = CGRectMake(0, 0, 30, 30);
    [alertBtn setImage:image forState:UIControlStateNormal];
    [alertBtn addTarget:self action:@selector(leftClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *alertCount = [[UILabel alloc] initWithFrame:CGRectMake(13, -6, 16, 16)];
    alertCount.text = title;
    alertCount.font = [UIFont systemFontOfSize:12];
    alertCount.backgroundColor = [UIColor redColor];
    alertCount.layer.cornerRadius = 8;
    alertCount.layer.masksToBounds = YES;
    alertCount.textAlignment = NSTextAlignmentCenter;
    [alertBtn addSubview:alertCount];
    
    [self setNavLeftItem:VC withCustomView:alertBtn];
}

- (void)setNavLeftItem:(UIViewController *)VC withCustomView:(UIButton *)leftBtn {

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    VC.navigationItem.leftBarButtonItem = leftItem;
}

- (void)leftClickAction {
    self.leftClick();
}

#pragma  mark - 设置右边的按钮

- (void)setNavRightItem:(UIViewController *)VC withItemTitle:(NSString *)title textColor:(UIColor *)color {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 50);
    if (color) {
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
    }
    
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNavRightItem:VC withCustomView:rightBtn];
    
}

- (void)setNavRightItem:(UIViewController *)VC withCustomView:(UIButton *)rightBtn {

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    VC.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBtnAction {
    self.rightClick();
}


#pragma mark - Customize

/**
 *  自定义全局导航栏
 */
- (void)customGlobleNavigationBarStyle {
#warning TODO: JUST RETURN IF NO NEED TO CHANGE Global Navigation Bar
    // 自定义导航栏背景
    if ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedDescending ) {
        [[UINavigationBar appearance] setBarTintColor:MainBackgroudColor_GrayAndWhite];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MainTextColor_DarkBlack}];
        
        [[UINavigationBar appearance] setTintColor:MainTextColor_DarkBlack];
        
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0 green:1.f*0xb4/0xff blue:1.f alpha:1.f]];
    } else {
        
        //UIImage *originImage = [UIImage imageNamed:@"pub_title_bg"];
        //UIImage *backgroundImage = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(44, 7, 4, 7)];
        //[[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBarTintColor:MainBackgroudColor_GrayAndWhite];
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor clearColor];
        shadow.shadowOffset = CGSizeMake(0,0);
        
        NSDictionary *barTitltAttributes = @{NSForegroundColorAttributeName:MainTextColor_DarkBlack,
                                             NSShadowAttributeName: shadow,
                                             NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]};
        [[UINavigationBar appearance] setTitleTextAttributes: barTitltAttributes];
        
        NSDictionary *barButtonTittleAttributes = @{NSForegroundColorAttributeName: MainTextColor_DarkBlack,
                                                    NSShadowAttributeName: shadow,
                                                    NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};
        
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTitleTextAttributes:barButtonTittleAttributes
                                                                                                                forState:UIControlStateNormal];
        
        UIImage *backItemImage = [[UIImage imageNamed:@"arrow_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30, 0, 0)
                                                                                    resizingMode:UIImageResizingModeStretch];
        
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class] ]]
                                         setBackButtonBackgroundImage:backItemImage
                                                             forState:UIControlStateNormal
                                                           barMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class] ]]
                                                   setBackgroundImage:[UIImage new]
                                                            forState:UIControlStateNormal
                                                           barMetrics:UIBarMetricsDefault];
        
//        [[UITabBar appearance] setBackgroundImage:backgroundImage];
//        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}
    
    
    // 自定义导航栏及导航按钮，可参考下面的文章
    // http://www.appcoda.com/customize-navigation-status-bar-ios-7/
}



@end
