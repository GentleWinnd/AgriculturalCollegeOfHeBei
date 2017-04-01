//
//  AccessTokenManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/28.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AccessTokenManager.h"
#import "UserData.h"
#import "KTMError.h"

@implementation AccessTokenManager

+ (BOOL)accessTokenIsValid {
    NSDate *accessTokenDate = [UserData getAccessTokenDate];
    NSTimeInterval interval = [accessTokenDate timeIntervalSinceNow];
    double refreshedTime = 60*60*24*7;
    if (interval>0) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)refreshToken:(void(^)(bool getToken))refresh failure:(void(^)(NSError *error))failure {
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:[UserData getRefreshToken], REFRESH_TOKEN, nil];
    
    __weak __typeof(self) weakSelf = self;
    [NetServiceAPI getRefreshTokenWithParameters:parameters success:^(id responseObject) {
        int status = [[responseObject valueForKey:@"status"] intValue];
        if (status == 200) {
            NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            [resultDic removeObjectForKey:@"result"];
            [resultDic removeObjectForKey:@"status"];
            [resultDic setValue:[NSDate date] forKey:ACCESS_TOKEN_DATE];
            
            if (refresh) {
                refresh(YES);
            }
            
        } else if (status == 401) { // refresh token 过期
            if (refresh) {
                refresh(NO);
            }
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            
            //[strongSelf showLoginInViewController:viewController];
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
        //[Progress progressShowcontent:[KTMError netError:error]];
    }];
}



@end
