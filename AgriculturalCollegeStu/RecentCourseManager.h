//
//  RecentCourseManager.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/6.
//  Copyright © 2017年 YH. All rights reserved.
//

typedef NS_ENUM(NSInteger, DataItem) {
    DataItemStartDate,
    DataItemEnddate,
    DataItemLessonTime,
    DataItemCourseId,
    DataItemActivityId,
    DataItemDependentId,
    DataItemDependentType,
    DataItemDependentName,
    DataItemCourseName
};

#import <Foundation/Foundation.h>

@interface RecentCourseManager : NSObject



/**
 get recent sign activity

 @param view view
 @param success scuccess
 @param failure failure
 */
+ (void)getRecentSignedActivityInView:(UIView *)view success:(void(^)(NSDictionary *activitysInfo))success failure:(void(^)(NSString *failMessage))failure;


/**activitysInfo
 get recent course

 @param view view
 @param success success
 @param failure failure
 */
+ (void)getRecentCourseInView:(UIView *)view success:(void(^)(NSDictionary *coursesInfo))success failure:(void(^)(NSString *failMessage))failure;

/**
 get recent course
 
 */
+ (void)getRecentCourseSuccess:(void(^)(NSDictionary *coursesInfo))success failure:(void(^)(NSString *failMessage))failure;


/**
 get recent sign activity

 @return recent sign activity 
 */
+ (NSDictionary *)getRecentSignActivity;


/**
 get recent course info

 @param dataItem data type
 @return item 
 */
+ (NSString *)getRecentCourseDataWithDateItem:(DataItem)dataItem;


/**
 get recnet activity info

 @param dataItem data type
 @return get item
 */
+ (NSString *)getRecentSignActivityDataWithDateItem:(DataItem)dataItem;


/**
 save recent course

 @param courseInfo save courseinfo
 */
+ (void)saveRecentCourse:(NSDictionary *)courseInfo;
@end

