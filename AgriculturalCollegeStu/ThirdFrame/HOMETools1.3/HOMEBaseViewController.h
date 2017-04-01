//
//  HOMEBaseViewController.h
//  HomeToolsTesr
//
//  Created by mahaomeng on 15/7/6.
//  Copyright (c) 2015年 mahaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 ====================================================================================================//HOMEMethod
 */
#import "HOMEHeader.h"
#import "HOMETools.h"
#import "HOMEButon.h"
#import "HOMETextField.h"
#import "UIColor+homecate.h"
#import "NSString+PinyinCategory.h"
#import "NSDate+HOMECategory.h"
#import "NSString+HOMECategory.h"
#import "HOMEEdgeView.h"
#import "HOMELabel.h"
/*
 ====================================================================================================//三方内容
 */
#import "AFHTTPSessionManager.h"
#import "UIKit+AFNetworking.h"
#import "MJRefresh.h"
#import "MJNIndexView.h"
//#import "MobClick.h"

static const CGFloat kTitleFont = 19;

@interface HOMEBaseViewController : UIViewController
{
    /** HOMEBaseViewController:AFN网络请求单例 */
    AFHTTPSessionManager *_AFNManager;
    
    /** HOMEBaseViewController:HOMEMBProgressHUD优化的进度指示 */
    
    /** HOMEBaseViewController:NSUserDefaults单例 */
    NSUserDefaults *_userDefaults;
    
}

@property (nonatomic, retain) NSUserDefaults *userDefaults;
@property (nonatomic, retain) AFHTTPSessionManager *AFNManager;
/** HOMEBaseViewController: 获取设备的uuid */
-(NSString*)uuid;

@end
