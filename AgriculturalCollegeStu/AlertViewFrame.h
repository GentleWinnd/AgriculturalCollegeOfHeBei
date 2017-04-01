//
//  AlertViewFrame.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/29.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertViewFrameDelegate <NSObject>

- (void)alertViewActionConfirm:(BOOL)confrim;

@end

@interface AlertViewFrame : NSObject

@property (assign, nonatomic) id<AlertViewFrameDelegate>delegate;
/**
 ceate alert view

 @param title title
 @param message showDetail
 @param confirm confirmBtntitle
 @param cancle cancleBtnTitle
 @param VC showInView
 */
- (void)alertViewWithTitle:(NSString *)title message:(NSString *)message confirm:(NSString *)confirm cancle:(NSString *)cancle showInView:(UIViewController *)VC;


/**
 alert click action

 @param confirm conriem
 @param cancle cancle
 */
//- (void)alertClickAction:(void(^ __nullable)())confirm cancle:(void(^ __nullable)())cancle;
//

@end
