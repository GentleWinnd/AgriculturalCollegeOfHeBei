//
//  AppDelegate+UMComponents.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/30.
//  Copyright © 2016年 YH. All rights reserved.
//
#define UMAPPKEY @"583e3383c62dca08e2002070"
#define UMMASSAGE_ALIAS_TYPE @"nongxuewang"



#import "AppDelegate+UMComponent.h"
#import "UMessage.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMMobClick/MobClick.h>

#import "AlertViewFrame.h"
#import "NotificationManager.h"
#import "SPKitExample.h"
//#import "JLRoutes.h"
#import "UserData.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate(UMComponent)<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (UMComponent)

#pragma mark - 友盟分享

- (void)initUMShare {
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置友盟appkey
    /**
     * testAppKey:583e3383c62dca08e2002070
     */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAPPKEY];
    
    //设置微信的appKey和appSecret
    /**
     * appkey:wx9a7b28823b9d9f9f
     * appSecret:dd8d4d4178edf5a06b68a691d2211e94
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9a7b28823b9d9f9f" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     * 添加某一平台会加入平台下所有分享渠道，如微信：好友、朋友圈、收藏，QQ：QQ和QQ空间
     * 以下接口可移除相应平台类型的分享，如微信收藏，对应类型可在枚举中查找
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    //设置分享到QQ互联的appID
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    /**
     * App key：2953634432
     * App secret：6731d0e57b70ff2d9390a1a78e2d1d95
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2953634432"  appSecret:@"6731d0e57b70ff2d9390a1a78e2d1d95" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //    //支付宝的appKey
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    //设置易信的appKey
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    //设置点点虫（原来往）的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    //设置领英的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    //
    //    //设置Twitter的appKey和appSecret
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    //
    //    //设置Facebook的appKey和UrlString
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
    //
    //    //设置Pinterest的appKey
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    //
}


#pragma mark - 友盟推送

- (void)initUMPushWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //设置 AppKey 及 LaunchOptions
    /**
     * appkey: 583e3383c62dca08e2002070
     */
    [UMessage startWithAppkey:UMAPPKEY launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_10_0
    //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title=@"打开应用";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title=@"忽略";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
    actionCategory1.identifier = @"category1";//这组动作的唯一标示
    [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
    [UMessage registerForRemoteNotifications:categories];
    
    //如果对角标，文字和声音的取舍，请用下面的方法
    UIRemoteNotificationType types7 = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
    UIUserNotificationType types8 = UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge;
    [UMessage registerForRemoteNotifications:categories withTypesForIos7:types7 withTypesForIos8:types8];
    
#endif
    
    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        
        /**
         * UNNotificationCategoryOptionNone
         * UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
         * UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
         */
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
    }
    
    //for log
    [UMessage setLogEnabled:YES];
    //notice set UMAlias
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UMSetAlias) name:NOTICE_USERROLE_CHANGED object:nil];
    //add oberver notice push
    [[NotificationManager sharePushNotification] addPushNoticeObserver];
}

#pragma mark - set UMAlias

- (void)UMSetAlias {

    [UMessage setAlias:[UserData getUser].userID type:UMMASSAGE_ALIAS_TYPE response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
        
    }];

}

#pragma mark - 远程通知接收

- (void)UMComponentsDidReceiveRemoteNotification:(NSDictionary *)userInfo {
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:@{@"userinfo":[NSString stringWithFormat:@"%@",userInfo]}];
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
//    NSLog(@"-=-=-=-=%@",userInfo);

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
       // [UMessage didReceiveRemoteNotification:userInfo];
        
        [[NotificationManager sharePushNotification] postPushNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    NSLog(@"-=-=-=-=%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        //[UMessage didReceiveRemoteNotification:userInfo];
        [[NotificationManager sharePushNotification] postPushNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

#pragma mark - 友盟统计

- (void)initUMAnalytics {
    UMConfigInstance.appKey = UMAPPKEY;
    //UMConfigInstance.secret = @"secretstringaldfkals";
    
    UMConfigInstance.channelId = @"App Store";
    //UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    //[MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //[MobClick startWithConfigure:UMConfigInstance];
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

#pragma mark - 即时通信

- (void)initIMAssage {
    
    /*
     * App Key:23553490
     * App Secret:08a3759d6d0a8026f9d6d24d39b776b4
     */
    
    dispatch_async(dispatch_queue_create("APP_EXPIRE_KILL", 0), ^{
        // 检查程序是否过期
        //MUPP_ALREADY_MODIFIED_TAG
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d yyyy"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSDate *expiresDate = [formatter dateFromString:[NSString stringWithFormat:@"%s", __DATE__]];
        
        // 一周过期
        if (now - [expiresDate timeIntervalSince1970] >=15*24*3600) {
            SEL expiredSelector = NSSelectorFromString(@"mupp_enterpriseBundleHasExpired");
            
            if ([self respondsToSelector:expiredSelector])
            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:expiredSelector];
#pragma clang diagnostic pop
                
                return;
            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您使用的程序是测试版本，目前已经过期，请更新到最新版本"
//                                                                message:nil
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil];
//                [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
//                
//                sleep(10);
//                kill(getpid(), 9);
            }
        }
    });
    
    // YWSDK快速接入接口，程序启动后调用这个接口
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    
    // 从这到当前方法结束是您的业务代码
    NSLog(@"Path:%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
}

#pragma mark - Routable
- (void)setupRoteWithUrl:(NSURL *)url {
    if ([url.scheme isEqualToString:@"openimdemo"]) {
//        [JLRoutes routeURL:url];
    }

//    [JLRoutes addRoute:@"/searchTribe" handler:^BOOL(NSDictionary *parameters) {
//        if ([parameters[@"tribeId"] length] == 0) {
//            return NO;
//        }
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
//        SPSearchTribeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPSearchTribeViewController"];
//        controller.searchText = parameters[@"tribeId"];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//        
//        [self.window.rootViewController presentViewController:navigationController
//                                                     animated:YES
//                                                   completion:NULL];
//        return YES;
//    }];
}




@end
