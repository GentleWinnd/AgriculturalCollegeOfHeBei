//
//  NotificationManager.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/5.
//  Copyright © 2017年 YH. All rights reserved.
//

#define PUSH_NOTICE @"pushNotice"

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject

/**
 singlton

 @return return NotificationManager 
 */
+ (instancetype)sharePushNotification ;

/**
 post  push notice

 @param userInfo push content
 */
- (void)postPushNotification:(NSDictionary *)userInfo;


/**
 add push notice observer
 */
- (void)addPushNoticeObserver;


@end
