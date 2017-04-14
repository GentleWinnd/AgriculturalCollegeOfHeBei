//
//  NetServiceAPI.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//
/*************************requeste tag**************************/
#define TEACH_ATTITUTED_ID @"1de3021b-37f9-40b7-a05e-5dff1398036f"
#define TEACH_ABILITY_ID @"3d09abde-2ca5-44cf-a93c-35cb4dbf4605"
#define TEACH_COACH_ID @"fa0dcbb9-ef10-4626-9ae0-9b4001dc96ed"

/************************API************************/

/**
 课程接口
 @return
 */
#define URL_COURSES @"http://templmsapi.bjdxxxw.cn/Course/NewestMVCCourses?Count="

#define URL_BASES @"http://templmsapi.bjdxxxw.cn/"
//获取所有分类列表
#define URL_CATEGORY_ALLS @"Category/All"
//分页获取课程数据
#define URL_COURSE_LISTS @"http://templmsapi.bjdxxxw.cn/Course/Paging?CategoryId=%@&CourseType=MVC&Sort=CreateDate&SortType=DESC&PageNum=1&PageSize=50"
//获取（微课）课程详细信息
#define URL_VIDEO_DETAILS @"http://templmsapi.bjdxxxw.cn/Course/MVCDetails?Id=%@&ImageWidth=129"

#define URL_MOOC_DETAIL @"http://templmsapi.urart.cc/Course/MOOCCourseVersionDetails?CourseVersionId=ProtoType@9bc030e3-6b5e-4691-95fb-e9f7ca08d8b5"

//获取反馈信息接口
#define HOST_GET_RECUPERATION @"http://appcloudapi.lndx.edu.cn/Feedback/Current?DependentId=tutorial&DependentType=app"
//提交反馈
#define HOST_SUBMIT_OPINION @"http://appcloudapi.lndx.edu.cn/Feedback/Submit"



/****************************NewAPI*************************/
#define  HOST_SERVICE @"http://ndlms_service.urart.cc/%@"

//about us
#define HOST_ABOUTUS @"/http://nduserservice.urart.cc/AutoUpdate/GetNewestAutoUpdate?applicationName=NDIOSClient"


/**********************************************************/
#import <Foundation/Foundation.h>

@interface NetServiceAPI : NSObject
/*******************course video*****************/
// get courseList
+ (void)getCourseListWithParameters:(id)parameters
                            success:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

// get all coursesList
+ (void)getALLCourseListWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

// get subCourseList
+ (void)getSubCourseListWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

//get microcourseInfo
+ (void)getMicroCourseInfoWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure;

//获取mooccourseInfo
+ (void)getMoocInfoWithParameters:(id)parameters
                          success:(void(^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//get courseListInfo
+ (void)getCourseListInfoWithParameters:(id)parameters
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;

// get MOOCCourseVersionDetails
+ (void)getMOOCCourseVersionDetailsWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure;

// get MVCCourseVersionDetails
+ (void)getMVCCourseDetailsWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

/********************NewCourseVideo********************/
//get courseListInfo
+ (void)getMOOCSCourseWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;
//post signup MCOV 
+ (void)postSignUpMCOVWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;
//the course collected
+ (void)getTheCourseCollectedWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

// set the ocurse collection state
+ (void)postTheCourseCollectedStateWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure;
/********************userData*********************/
#pragma mark - userdata
//post login
+ (void)postLoginInfoWithParameters:(id)parameters
                            success:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;

//get userrole info
+ (void)getUserRoleInfoWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

// get app recuperation
+ (void)getAPPRecuperationWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure;

//submit options
+ (void)postSubmitOptionsWithParameters:(id)parameters
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure;
//get about us info
+ (void)getAboutUsInfoWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;

//get user info
+ (void)getUserInfoWithParameters:(id)parameters
                          success:(void(^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure;

//get FeedBack Mail

+ (void)getFeedBackMailWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

//post log error
+ (void)postLogErrorWithParameters:(id)parameters
                           success:(void(^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure;

+ (void)postUserAvaterWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;

+ (void)postUploadImageImageData:(NSData *)imageData
                     nameOfImage:(NSString *)name
                      fileOfName:(NSString *)fileName
                      mimeOfType:(NSString *)mineType
                        progress:(void (^) (NSProgress *uploadProgress))progress
                          sucess:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure;
/*************************accessToken*******************/
#pragma  mark - access token
//verificationAccessToken
+ (void)getVerificationAccessTokenWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure;

//refreshAccessToken
+ (void)postRefreshTokenWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;
/*************************courseData***********************/
#pragma mark - course data
+ (void)getAllOfflineCourseWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;
//getreCentCourse
+ (void)getRecentCourseWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

//getrecentSignedActivity
+ (void)getRecentSignActiveWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

// post signed info
+ (void)postSignedInfoWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;

//check location in range
+ (void)getLocationInRangeWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure;
//get students signed state
+ (void)getSignedStudentStateWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;
// get signed students info
+ (void)getSignedStudentsInfoWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

// get class schecdule
+ (void)getClassScheduleWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

#pragma mark - leaved approval API
//post leaved approval
+ (void)postLeaveResonWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure;
// get signed students info
+ (void)getLeavedInfoWithParameters:(id)parameters
                            success:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure;
// get my leaved info list
+ (void)getMyLeavedInfoListWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;
// get my wait approval list
+ (void)getMyWaitApprovalsInfoListWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure;
// get my wait approval list
+ (void)getMyCompletedApprovalsListWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure;
//post agree approval info
+ (void)postAgreeApprovalInfoWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;
//post turndown approval info
+ (void)postTurndownApprovalInfoWithParameters:(id)parameters
                                       success:(void(^)(id responseObject))success
                                       failure:(void(^)(NSError *error))failure;
#pragma mark - teach evaluation
//post  teach evaluation
+ (void)postTeachEvaluationWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;
// get teach evaluation item list
+ (void)getTeachEvaluationItemListWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure;
// get teach evaluation  contents list
+ (void)getTeachEvaluationContensWithParameters:(id)parameters
                                        success:(void(^)(id responseObject))success
                                        failure:(void(^)(NSError *error))failure;

#pragma mark - class test 

//PublishClassTest
+ (void)postPublishClassTestWithParameters:(id)parameters
                                   success:(void(^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure;
//student sumite ClassTest
+ (void)postStudentClassTestAnswerWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure;
// get student temporaryTest statistical rasult
+ (void)getStudentTemporaryTestResultWithParameters:(id)parameters
                                            success:(void(^)(id responseObject))success
                                            failure:(void(^)(NSError *error))failure;
// get the temporaryTest detail
+ (void)getTheTemporaryDetailWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

//get  OfflineCourse/ExerciseDetails
+ (void)getTheExerciseDetailsWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure;

//get OfflineCourse/ExerciseDetailsByTeacher
+ (void)getTheExerciseDetailsOfTeacherWithParameters:(id)parameters
                                             success:(void(^)(id responseObject))success
                                             failure:(void(^)(NSError *error))failure;
// get The ExerciseState
+ (void)getTheExerciseStateWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

//get Exercise StatDetail
+ (void)getTheExerciseStateDetailWithParameters:(id)parameters
                                        success:(void(^)(id responseObject))success
                                        failure:(void(^)(NSError *error))failure;
//get Exercise StatRightWrongRate
+ (void)getTheExerciseStateRightWrongRateWithParameters:(id)parameters
                                                success:(void(^)(id responseObject))success
                                                failure:(void(^)(NSError *error))failure;

//post exercise answers
+ (void)postExerciseAnswersWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

#pragma mark - student school assignment
// get student school assignment
+ (void)getSchoolAssignmentWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

+ (void)getHomeWorkDetailsByTeacherWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure;

//post student school assignment
+ (void)postStudentSchollAssignmentWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure;

// get  HomeWork/Stat
+ (void)getHomeWorkStateWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure;

//get home work statedetail
+ (void)getHomeWorkStateDetailWithParameters:(id)parameters
                                     success:(void(^)(id responseObject))success
                                     failure:(void(^)(NSError *error))failure;

///HomeWork/UploadAttachment 上传作业附件
+ (void)postUploadHomeWorkAttachmentsWithParameters:(id)parameters
                                            success:(void(^)(id responseObject))success
                                            failure:(void(^)(NSError *error))failure;


///HomeWork/RemoveAttachment 移除作业的附件
+ (void)postRemoveHomeWorkAttachmentsWithParameters:(id)parameters
                                            success:(void(^)(id responseObject))success
                                            failure:(void(^)(NSError *error))failure;

#pragma mark - get class Source

+ (void)getClassSourcesWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure;

/******************************collection course******************************/
#pragma mark - favorite course

//post favorite course
+ (void)postCollectionFavoriteWithParameters:(id)parameters
                                     success:(void(^)(id responseObject))success
                                     failure:(void(^)(NSError *error))failure;

//get favorite course list
+ (void)getFavoriteSourcesWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure;
//check course favorite state
+ (void)getCheckSourceCollectedStateWithParameters:(id)parameters
                                           success:(void(^)(id responseObject))success
                                           failure:(void(^)(NSError *error))failure;

/**********************class group********************/
#pragma mark - class group
//get Group/List
//check course favorite state

+ (void)getClassGroupSourseWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

/**********************day class schedule********************/
#pragma mark - day class schedule
//get Schedule/TodayStat
+ (void)getClassDayScheduleWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure;

//get ClassAndGroup DaySchedule List
+ (void)getClassAndGroupDayScheduleListWithParameters:(id)parameters
                                              success:(void(^)(id responseObject))success
                                              failure:(void(^)(NSError *error))failure;

//get Class Day Schedule Recentest Activity
+ (void)getClassDayScheduleRecentestActivityWithParameters:(id)parameters
                                                   success:(void(^)(id responseObject))success
                                                   failure:(void(^)(NSError *error))failure;

//get Class DaySchedule RangeActivitys
+ (void)getClassDayScheduleRangeActivitysWithParameters:(id)parameters
                                                success:(void(^)(id responseObject))success
                                                failure:(void(^)(NSError *error))failure;
#pragma mark - 获取统计报表列表
///OfflineCourse/ListGroupByYear 获取统计报表列表

+ (void)getOfflineCourseListGroupByYearWithParameters:(id)parameters
                                              success:(void(^)(id responseObject))success
                                              failure:(void(^)(NSError *error))failure;

//OfflineCourse/Stat 获取统计报表详情

+ (void)getOfflineCourseStatisticalDetailWithParameters:(id)parameters
                                                success:(void(^)(id responseObject))success
                                                failure:(void(^)(NSError *error))failure;

//按月获取统计报表详情
+ (void)getOfflineCourseStatisticalDetailByMonthWithParameters:(id)parameters
                                                       success:(void(^)(id responseObject))success
                                                       failure:(void(^)(NSError *error))failure;


#pragma mark - 发起提问

///OfflineCourse/AskQuestionMemberStat 获取发起提问学生详情

+ (void)getOfflineCourseAskQuestionMemberStatWithParameters:(id)parameters
                                                    success:(void(^)(id responseObject))success
                                                    failure:(void(^)(NSError *error))failure;

//OfflineCourse/AskQuestionEvaluation上传教师对于学生的评价

+ (void)postOfflineCourseAskQuestionEvaluationWithParameters:(id)parameters
                                                     success:(void(^)(id responseObject))success
                                                     failure:(void(^)(NSError *error))failure;

//OfflineCourse/AskQuestionLaunchPush 发起提问

+ (void)postOfflineCoorseSponsorQuestionWithParameters:(id)parameters
                                               success:(void(^)(id responseObject))success
                                               failure:(void(^)(NSError *error))failure;
@end


