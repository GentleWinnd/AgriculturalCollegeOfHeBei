//
//  AccessTokenManager.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/28.
//  Copyright © 2016年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessTokenManager : NSObject

+ (BOOL)accessTokenIsValid;

+ (void)refreshToken:(void(^)(bool getToken))refresh failure:(void(^)(NSError *error))failure;
@end
