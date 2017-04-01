//
//  ClassScheduleViewController.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/13.
//  Copyright © 2016年 YH. All rights reserved.
//
/*
 "Id": "a56106bc-ed87-4bf7-b368-1437428a0ccf",
 "CheckInSetting_Location": "北京市西城区复兴门内大街160号中央广播电视大学",
 "Name": "农业经济学",
 "RecentestActivity": {
 "Id": "34f38cb6-529e-42aa-a7d6-bea7712dfe96",
 "StartDate": "2017-01-10T16:00:00",
 "EndDate": "2017-01-10T18:00:00",
 "Dependent": {
 "DependentId": "a56106bc-ed87-4bf7-b368-1437428a0ccf",
 "DependentType": "Batch",
 "DependentName": "农业经济学"
 }
 }
 */
#define COURSE_NAME @"Name"
#define COURSE_ID @"Id"
#define COURSE_RECENTACTICE @"RecentestActivity"
#define COURSE_RECENTACTICE_ID @"Id"
#define COURSE_RECENTACTICE_DEPENDENT @"Dependent"
#define COURSE_RECENTACTICE_DEPENDENT_TYPE @"DependentType"
#define COURSE_RECENTACTICE_DEPENDENT_NAME @"DependentName"
#define COURSE_RECENTACTICE_DEPENDENT_ID @"DependentId"
#define COURSE_TIME @"LessonTime"

typedef  void(^selectedClass)(NSDictionary *courseInfo);

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ClassScheduleViewController : BaseViewController


@property (nonatomic, copy) selectedClass theSelectedClass;

@end

@interface lineView : UICollectionReusableView



@end
