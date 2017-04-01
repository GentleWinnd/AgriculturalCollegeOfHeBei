//
//  AppDelegate+UMComponents.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/30.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AppDelegate.h"
#import <WXOUIModule/YWUIFMWK.h>

@interface AppDelegate (UMComponent)

@property (strong, nonatomic, readwrite) YWIMKit *ywIMKit;


/**
 友盟分享
 */

- (void)initUMShare;

/**
 友盟推送
 @param application application
 @param launchOptions launchOptions
 */
- (void)initUMPushWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 远程通知接收
 @param userInfo userInfo
 */
- (void)UMComponentsDidReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 友盟统计
 */
- (void)initUMAnalytics;

/**
 即时通信
 */
- (void)initIMAssage;


/**
 Routable

 @param url url
 */
- (void)setupRoteWithUrl:(NSURL *)url;
@end
