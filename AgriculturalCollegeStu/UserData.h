//
//  userData.h
//  KTMExpertCheck
//
//  Created by tongrd on 15/11/4.
//  Copyright © 2015年 kaitaiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


#define USERNAME @"username"
#define USERID @"id"
#define PASSWORD @"password"
#define NICKNAME @"nickName"

@class User;

@interface UserData : NSObject

/**
 * get user
 */
+ (User *)getUser;
+ (void)saveUserData:(NSDictionary *)userData;


+ (NSString *)getAccessToken;

+ (NSDate *)getAccessTokenDate;

+ (NSString *)getRefreshToken;

/**
 *  receive the data returned after a successful user login
 */
+ (void)receiveData:(NSDictionary *)data password:(NSString *)password;

/**
 *  storing user data
 */
+ (void)storeUserData:(User *)KTMUser;

/**
 *  empty the user data
 */
+ (void)removeUserData;

/**
 *  get the user ID
 */
+ (NSString *)getUserID;

/*
 *  get the user login name
 */
+ (NSString *)getUserName;

/**
 * get user password
 */
+ (NSString *)getUserPassword;

#pragma mark -  saved user role

+ (void)saveUserHeaderPortrait:(NSData *)imageData;

@end
