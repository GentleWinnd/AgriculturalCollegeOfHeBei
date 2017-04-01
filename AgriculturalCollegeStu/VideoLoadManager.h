//
//  VideoLoadManager.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/9.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoLoadManager : NSObject

+ (instancetype)shareVideoManager;

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag withInfo:(NSDictionary *)info andCoverUrl:(NSString *)cover andSubId:(NSString *)subId andSubTitle:(NSString *)subTitle;

@end
