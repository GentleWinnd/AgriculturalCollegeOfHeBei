//
//  NoticeViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^refreshedNoticeNum)(void);

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController
@property (assign, nonatomic) UserRole userRole;
@property (assign, nonatomic) BOOL showUnreadNews;
@property (copy, nonatomic) refreshedNoticeNum refreshed;

@end
