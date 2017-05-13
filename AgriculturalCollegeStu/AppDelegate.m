//
//  AppDelegate.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/11/29.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import "ClassVideoViewController.h"
#import "ClassRoomViewController.h"
#import "MineViewController.h"

#import "AppDelegate+UMComponent.h"
#import "SetNavigationItem.h"
#import "VideoLoadManager.h"
#import "SourseDataCache.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupViewControllers];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    [self initIMAssage];
    [VideoLoadManager shareVideoManager];
    [self initUMPushWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self initUncaughtExceptionHandler];
    return YES;
}


#pragma mark - 设置tabbar子类view

- (void)setupViewControllers {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];

    ClassRoomViewController *classRoomViewController = [board instantiateViewControllerWithIdentifier:@"classRoom_sb"];
    classRoomViewController.title = @"首页";
    UINavigationController *classRoomNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:classRoomViewController];
    
    ClassVideoViewController *classVViewController = [board instantiateViewControllerWithIdentifier: @"classVideo_SB"];
    classVViewController.title = @"慕课";
    UINavigationController *classVNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:classVViewController];
    
    MineViewController *thirdViewController = [board instantiateViewControllerWithIdentifier:@"mine_sb"];
    thirdViewController.title = @"我的";
    UINavigationController *mineNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[classRoomNavigationController, classVNavigationController,
                                           mineNavigationController]];
    
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    //设置tabbar的背景色
   // UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    //UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"classRoom", @"loveClass", @"person"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        //[item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_d",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
    [[SetNavigationItem shareSetNavManager] customGlobleNavigationBarStyle];
}

#pragma mark - 远程通知接收

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self UMComponentsDidReceiveRemoteNotification:userInfo];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [self setupRoteWithUrl:url];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
     //[UMessage registerDeviceToken:deviceToken];
    
    //下面这句代码只是在demo中，供页面传值使用。
    //[self postTestParams:[self stringDevicetoken:deviceToken] idfa:[self idfa] openudid:[self openUDID]];
    
    NSString *result  =[deviceToken description];
    NSString *strUrl = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
}

 - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
 //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
 //1.2.7版本开始自动捕获这个方法，log以application:didFailToRegisterForRemoteNotificationsWithError开头
 }


/***************************get crash log**************************/

#pragma mark - init UncaughtExceptionHandler
- (void)initUncaughtExceptionHandler {
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    ;
    NSString *crashInfo = [NSString stringWithFormat:@"错误详情（%@）:<br>%@<br>---------------<br>%@<br>--------------<br>%@",currentVersion,name,reason,[arr componentsJoinedByString:@"<br>"]];
    [SourseDataCache saveAppCrashLogInfo:crashInfo];

    NSString *urlStr = [NSString stringWithFormat:@"mailto://wj2929@gmail.com?subject=Bug报告&body=感谢您的配合<br><br><br>错误详情（%@）:<br>%@<br>---------------<br>%@<br>--------------<br>%@",currentVersion,name,reason,[arr componentsJoinedByString:@"<br>"]];
    //NSURL *URL = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:@[]]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"XingXue_Pro"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
