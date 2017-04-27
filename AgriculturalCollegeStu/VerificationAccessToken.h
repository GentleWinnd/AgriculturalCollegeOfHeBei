//
//  VerificationAccessToken.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/4/6.
//  Copyright © 2017年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificationAccessToken : NSObject
/**
 * access token is valid
 */
+ (BOOL)accessTokenIsValid;

/**
 * refresh token
 */
+ (void)refreshToken:(void(^)(bool getToken))refresh
             failure:(void(^)(NSError *error))failure;


@end
