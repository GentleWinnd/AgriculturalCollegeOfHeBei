//
//  RecentCourseManager.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2017/1/6.
//  Copyright © 2017年 YH. All rights reserved.
//

#define RECENT_COURSE @"recentCourse"
#define RECENT_ACTICITY @"recentActivity"

#import "RecentCourseManager.h"
#import "SourseDataCache.h"

@interface RecentCourseManager()

@property (strong, nonatomic) NSDictionary *courseInfo;
@end

@implementation RecentCourseManager


#pragma mark - getrecentcourse

+ (void)getRecentCourseInView:(UIView *)view success:(void(^)(NSDictionary *coursesInfo))success failure:(void(^)(NSString *failMessage))failure {
    
    [NetServiceAPI getRecentCourseWithParameters:nil success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            if (failure) {
                failure(responseObject[@"Message"]);
                [Progress progressShowcontent:responseObject[@"Message"]];
            }
        } else {
            if (success) {
                [self saveRecentCourse:[NSDictionary safeDictionary:responseObject[@"RecentestActivity"]]];
                success([NSDictionary safeDictionary:responseObject[@"RecentestActivity"]]);
            }
        }
    } failure:^(NSError *error) {
        
        [KTMErrorHint showNetError:error inView:view];
        // NSLog(@"%@",error.description);
    }];
}

#pragma - mark get recent activity

+ (void)getRecentSignedActivityInView:(UIView *)view success:(void(^)(NSDictionary *activitysInfo))success failure:(void(^)(NSString *failMessage))failure {
    NSMutableDictionary *courseDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
        [courseDic setValuesForKeysWithDictionary: coursesInfo];
    } failure:^(NSString *failMessage) {
          [Progress progressShowcontent:@"获取最近课程信息失败"];
    }];
    if ([courseDic allKeys].count == 0) {
        return;
    }
//    NSDictionary *parameter =@{@"OfflineCourseId": courseDic[@"Dependent"][@"DependentId"]};
    NSDictionary *parameter =@{@"OfflineCourseId": @"00000000-0000-0000-0000-000000000000"};
    [NetServiceAPI getRecentSignActiveWithParameters:parameter success:^(id responseObject) {
        if ([responseObject[@"State"] integerValue]!= 1) {
            [Progress progressShowcontent:responseObject[@"Message"]];
        } else {
            if (success) {
                [self saveRecentSignActivity:[NSDictionary safeDictionary:responseObject[@"RecentestCheckInActivity"]]];
                success([NSDictionary safeDictionary:responseObject[@"RecentestCheckInActivity"]]);
            }
        }
        
    } failure:^(NSError *error) {
        
        [KTMErrorHint showNetError:error inView:view];
        // NSLog(@"%@",error.description);
    }];
}

/*
 "RecentestActivity": {
 "Id": "5ef6f3cc-8a48-42e8-8a42-0a39d1796b80",
 "StartDate": "2017-01-06T10:00:00",
 "EndDate": "2017-01-06T12:00:00",
 "Dependent": {
 "DependentId": "f062a9c7-815c-4233-bd17-83ce776ef285",
 "DependentType": "Batch",
 "DependentName": "动物解剖学"
 }
 },
 */


#pragma mark - get recent course

+ (void)getRecentCourseSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure {
    
    NSDictionary *courseDic = [SourseDataCache getRecentCourseInfo];
    if (courseDic == nil) {
        [self getRecentCourseInView:nil success:^(NSDictionary *courseInfo) {
            success(courseInfo);
        } failure:^(NSString *failMessage) {
            failure(failMessage);
        }];
    } else {
        success(courseDic);
    }
}

//+ (NSDictionary *)getRecentSignActivity {
//    
//    return [SourseDataCache getSignActicvityInfo];
//}


+ (NSString *)getRecentCourseDataWithDateItem:(DataItem)dataItem {
    NSMutableDictionary *courseDic = [NSMutableDictionary dictionaryWithCapacity:0];
     [self getRecentCourseSuccess:^(NSDictionary *coursesInfo) {
         [courseDic setValuesForKeysWithDictionary:coursesInfo];
    } failure:^(NSString *failMessage) {
        
    }];
    NSString *dataStr;
    switch (dataItem) {
        case DataItemEnddate:
            dataStr = courseDic[@"EndDate"];
            break;
        case DataItemStartDate:
            dataStr = courseDic[@"StartDate"];
            break;
        case DataItemCourseId:
            dataStr = courseDic[@"Id"];
            break;
        case DataItemDependentId:
            dataStr = courseDic[@"Dependent"][@"DependentId"];
            break;
        case DataItemDependentName:
            dataStr = courseDic[@"Dependent"][@"DependentName"];
            break;
        case DataItemDependentType:
            dataStr = courseDic[@"Dependent"][@"DependentType"];
            break;
            case DataItemLessonTime:
            dataStr = courseDic[@"LessonTime"];
        default:
            break;
    }
    return dataStr;
}

+ (NSString *)getRecentSignActivityDataWithDateItem:(DataItem)dataItem {
    NSDictionary *courseInfo = [self getRecentSignActivity];
    NSString *dataStr;
    switch (dataItem) {
        case DataItemEnddate:
            dataStr = courseInfo[@"EndDate"];
            break;
        case DataItemStartDate:
            dataStr = courseInfo[@"StartDate"];
            break;
        case DataItemCourseId:
            dataStr = courseInfo[@"Id"];
            break;
        case DataItemDependentId:
            dataStr = courseInfo[@"Dependent"][@"DependentId"];
            break;
        case DataItemDependentName:
            dataStr = courseInfo[@"Dependent"][@"DependentName"];
            break;
        case DataItemDependentType:
            dataStr = courseInfo[@"Dependent"][@"DependentType"];
            break;
            
        default:
            break;
    }
    return dataStr;
}


#pragma mark - save recent course

+ (void)saveRecentCourse:(NSDictionary *)courseInfo {
    if (courseInfo == nil) {
        return;
    }
    [SourseDataCache saveRecentCourseInfo:courseInfo];
}

#pragma mark - save recent sign activity

+ (void)saveRecentSignActivity:(NSDictionary *)signActivityInfo {
    if (signActivityInfo == nil) {
        return;
    }
//    [SourseDataCache saveSignActivityInfo:signActivityInfo];
}




@end
