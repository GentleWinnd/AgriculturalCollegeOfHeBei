//
//  NetServiceAPI.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/22.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "NetServiceAPI.h"
#import "KTMWebService.h"
#import "UserData.h"

@implementation NetServiceAPI

// 任务列表接口
+ (void)getCourseListWithParameters:(id)parameters
                            success:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:@"%@%@",URL_COURSES,[parameters allValues].lastObject];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 所有的课程列表接口
+ (void)getALLCourseListWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:@"%@%@",URL_BASES,URL_CATEGORY_ALLS];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


// 下部课程列表接口
+ (void)getSubCourseListWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:URL_COURSE_LISTS,[parameters allValues].lastObject];
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 获取微课
+ (void)getMicroCourseInfoWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:URL_VIDEO_DETAILS,[parameters allValues].lastObject];
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get courseListInfo
+ (void)getCourseListInfoWithParameters:(id)parameters
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    
    [KTMWebService CMGetWithURL:parameters[@"URL"] parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**********************NewCourseData************************/

//get courseListInfo
+ (void)getMOOCSCourseWithParameters:(id)parameters
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    
    NSString *sourseURL = [NSString stringWithFormat:@"Course/NewestCourses?Count=%@",parameters[@"count"]];
    NSString *URLStr = [NSString stringWithFormat:HOST_SERVICE, sourseURL];
    [KTMWebService CMGetWithURL:URLStr parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//Batch/SignUp
+ (void)postSignUpMCOVWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"Batch/SignUp";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//the course collected
+ (void)getTheCourseCollectedWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    NSString *sourseUrl = [NSString stringWithFormat:@"Favorites/Check?CourseId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// set the ocurse collection state
+ (void)postTheCourseCollectedStateWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"Favorites/Set";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取mooccourseInfo
+ (void)getMoocInfoWithParameters:(id)parameters
                          success:(void(^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure {
    NSString *sourseURL = [NSString stringWithFormat:@"/Course/MOOCCourseDetails?Id=%@&ImageWidth=300",[parameters allValues].lastObject];
    NSString *URLStr = [NSString stringWithFormat:HOST_SERVICE,sourseURL];
    [KTMWebService CMGetWithURL:URLStr parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get MOOCCourseVersionDetails
+ (void)getMOOCCourseVersionDetailsWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure {
    NSString *sourseURL = [NSString stringWithFormat:@"Course/MOOCCourseVersionDetails?CourseVersionId=%@",[parameters allValues].lastObject];
    NSString *URLStr = [NSString stringWithFormat:HOST_SERVICE,sourseURL];
    [KTMWebService CMGetWithURL:URLStr parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get MVCCourseVersionDetails
+ (void)getMVCCourseDetailsWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    NSString *sourseURL = [NSString stringWithFormat:@"Course/MVCDetails?Id=%@&ImageWidth=129",[parameters allValues].lastObject];
    NSString *URLStr = [NSString stringWithFormat:HOST_SERVICE,sourseURL];
    [KTMWebService CMGetWithURL:URLStr parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/*******************userData*******************/
#pragma mark - user data
//Passport/Login
+ (void)postLoginInfoWithParameters:(id)parameters
                            success:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"Passport/Login2";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get userrole info
+ (void)getUserRoleInfoWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    NSString *sourseUrl = @"Passport/GetUserRoleKeys?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get app recuperation

+ (void)getAPPRecuperationWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure {
    
    [KTMWebService CMGetWithURL:HOST_GET_RECUPERATION parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//submit options
+ (void)postSubmitOptionsWithParameters:(id)parameters
                                success:(void(^)(id responseObject))success
                                failure:(void(^)(NSError *error))failure {
    
    [KTMWebService CMPostWithURL:HOST_SUBMIT_OPINION parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get about us info
+ (void)getAboutUsInfoWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    
    [KTMWebService CMGetWithURL:HOST_ABOUTUS parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get("/Passport/GetStudentInfo?AccessToken=0b40b278-1607-43bc-b412-8fb740d05464"

//get user info
+ (void)getUserInfoWithParameters:(id)parameters
                          success:(void(^)(id responseObject))success
                          failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"Passport/GetStudentInfo?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

//get FeedBack Mail

+ (void)getFeedBackMailWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"Tools/Config";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//post log error
+ (void)postLogErrorWithParameters:(id)parameters
                           success:(void(^)(id responseObject))success
                           failure:(void(^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Log/Error"];
    [KTMWebService CMPostWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//post log error
+ (void)postUserAvaterWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Passport/SetAvatar"];
    [KTMWebService CMPostWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)postUploadImageImageData:(NSData *)imageData
                     nameOfImage:(NSString *)name
                      fileOfName:(NSString *)fileName
                      mimeOfType:(NSString *)mineType
                        progress:(void (^) (NSProgress *uploadProgress))progress
                          sucess:(void(^)(id responseObject))success
                         failure:(void(^)(NSError *error))failure {
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Passport/SetAvatar"];

    [KTMWebService postUploadImageWithURL:URL imageData:imageData nameOfImage:name fileOfName:fileName mimeOfType:mineType progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


/***********************dealwith Accesstoken***********************/
#pragma mark - dealwith accessyoken
// verificationAccessToken

+ (void)getVerificationAccessTokenWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure {
    NSString *sourseUrl = @"/Passport/Validation?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// token from refresh token
+ (void)postRefreshTokenWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    NSString *sourceUrl = @"/Passport/RefreshToken";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE,sourceUrl];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/***********************courseData*************************/
#pragma mark - courseData

//get("/OfflineCourse/List?AccessToken=45f1067c2fd847428a7e3634dd9d9ef2"
// getRecentCourse
+ (void)getAllOfflineCourseWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"OfflineCourse/List?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// getRecentCourse
+ (void)getRecentCourseWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"OfflineCourse/RecentestActivity?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// getRecentSignActive

+ (void)getRecentSignActiveWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/RecentestCheckInActivity?OfflineCourseId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// post signed info
+ (void)postSignedInfoWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"OfflineCourse/CheckIn";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//check in range
+ (void)getLocationInRangeWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/IsCheckInRange?OfflineCourseId=%@&CheckInActivityId=%@&GPSCoordinate=%@",parameters[@"OfflineCourseId"],parameters[@"CheckInActivityId"],parameters[@"GPSCoordinate"]];
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get signed students number
+ (void)getSignedStudentStateWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"CheckInActivity/StudentCheckInStat?CheckInActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get signed students info

+ (void)getSignedStudentsInfoWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"CheckInActivity/StudentCheckInStatDetail?CheckInActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get("/OfflineCourse/RangeActivitys?AccessToken=773daf60657f4bcaada90e5f5bd968ef&StartDate=2016-12-21&EndDate=2016-12-22"

// get signed students info

+ (void)getClassScheduleWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/RangeActivitys?StartDate=%@&EndDate=%@",parameters[@"StartDate"],parameters[@"EndDate"]];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - putup leaved approval
//post leave approval
+ (void)postLeaveResonWithParameters:(id)parameters
                             success:(void(^)(id responseObject))success
                             failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"OfflineCourse/AskLeave";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get leaved info
+ (void)getLeavedInfoWithParameters:(id)parameters
                            success:(void(^)(id responseObject))success
                            failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"AskLeave/Info?Id=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


// get my leaved info list
+ (void)getMyLeavedInfoListWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"AskLeave/My?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get my wait approval list
+ (void)getMyWaitApprovalsInfoListWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"AskLeave/WaitApprovals?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get my wait approval list
+ (void)getMyCompletedApprovalsListWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"AskLeave/CompleteApprovales?";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//post agree approval info
+ (void)postAgreeApprovalInfoWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"AskLeave/Agree";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//post turndown approval info
+ (void)postTurndownApprovalInfoWithParameters:(id)parameters
                                       success:(void(^)(id responseObject))success
                                       failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"AskLeave/Turndown";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - teach evaluation

//post  teach evaluation
+ (void)postTeachEvaluationWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"OfflineCourse/Evaluation";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get("/TeachEvaluation/EvaluationItemList"

// get teach evaluation item list
+ (void)getTeachEvaluationItemListWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = @"TeachEvaluation/EvaluationItemList";
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


// get teach evaluation  contents list
+ (void)getTeachEvaluationContensWithParameters:(id)parameters
                                        success:(void(^)(id responseObject))success
                                        failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"TeachEvaluation/EvaluationContent?ActivityId=%@&PageNum=1&PageSize=10",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



#pragma mark - class test

//post("/OfflineCourse/LaunchTemporaryTest",{AccessToken:"773daf60657f4bcaada90e5f5bd968ef",ActivityId:"3e45d826-aa7b-452a-be99-a6fde7baff78",QuestionType:"单选题",QuestionOptions:"A,B,C,D",RightAnswer:"D"}

//PublishClassTest

+ (void)postPublishClassTestWithParameters:(id)parameters
                                   success:(void(^)(id responseObject))success
                                   failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"OfflineCourse/LaunchTemporaryTest";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//student sumite ClassTest
+ (void)postStudentClassTestAnswerWithParameters:(id)parameters
                                         success:(void(^)(id responseObject))success
                                         failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"TemporaryTest/SubmitAnswer";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get student temporaryTest statistical rasult
+ (void)getStudentTemporaryTestResultWithParameters:(id)parameters
                                            success:(void(^)(id responseObject))success
                                            failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"TemporaryTest/StudentTemporaryTestStat?TemporaryTestQuestionId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService CMGetWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get the temporaryTest detail
+ (void)getTheTemporaryDetailWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"TemporaryTest/StudentTemporaryTestStatDetail?TemporaryTestQuestionId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get  /OfflineCourse/ExerciseDetails
+ (void)getTheExerciseDetailsWithParameters:(id)parameters
                                    success:(void(^)(id responseObject))success
                                    failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/ExerciseDetails?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

//get OfflineCourse/ExerciseDetailsByTeacher
+ (void)getTheExerciseDetailsOfTeacherWithParameters:(id)parameters
                                             success:(void(^)(id responseObject))success
                                             failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/ExerciseDetailsByTeacher?ActivityId=%@&StudentId=%@",parameters[@"ActivityId"],parameters[@"StudentId"]];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}



//get Exercise/State
+ (void)getTheExerciseStateWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"Exercise/Stat?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//get Exercise StatDetail
+ (void)getTheExerciseStateDetailWithParameters:(id)parameters
                                        success:(void(^)(id responseObject))success
                                        failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"Exercise/StatDetail?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//get Exercise StatRightWrongRate
+ (void)getTheExerciseStateRightWrongRateWithParameters:(id)parameters
                                                success:(void(^)(id responseObject))success
                                                failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"Exercise/StatRightWrongRate?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//post Exercise Student's ExerciseAnswers
+ (void)postExerciseAnswersWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"Exercise/SaveStudentExerciseAnswers";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - class school assignment

// get school assignments OfflineCourse/HomeWorkDetails
+ (void)getSchoolAssignmentWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/HomeWorkDetails?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get OfflineCourse/HomeWorkDetailsByTeacher
+ (void)getHomeWorkDetailsByTeacherWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/HomeWorkDetailsByTeacher?ActivityId=%@&&StudentId=%@",parameters[@"ActivityId"],parameters[@"StudentId"]];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



//post school assignment
+ (void)postStudentSchollAssignmentWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"HomeWork/SubmitAnswer2";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get  HomeWork/Stat
+ (void)getHomeWorkStateWithParameters:(id)parameters
                               success:(void(^)(id responseObject))success
                               failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"HomeWork/Stat?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// get HomeWork/StatDetail

+ (void)getHomeWorkStateDetailWithParameters:(id)parameters
                                     success:(void(^)(id responseObject))success
                                     failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"HomeWork/StatDetail?ActivityId=%@",[parameters allValues].lastObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

///HomeWork/UploadAttachment 上传作业附件
+ (void)postUploadHomeWorkAttachmentsWithParameters:(id)parameters
                                          success:(void(^)(id responseObject))success
                                          failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"HomeWork/UploadAttachment";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

///HomeWork/RemoveAttachment 移除作业的附件
+ (void)postRemoveHomeWorkAttachmentsWithParameters:(id)parameters
                                            success:(void(^)(id responseObject))success
                                            failure:(void(^)(NSError *error))failure {
    NSString *taskActionStr = @"HomeWork/RemoveAttachment";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



#pragma mark - class source

+ (void)getClassSourcesWithParameters:(id)parameters
                              success:(void(^)(id responseObject))success
                              failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"OfflineCourse/ResourceList?Keyword=%@&ResourceType=%@&OfflineCourseId=%@&PageNum=1&PageSize=10&",parameters[@"Keyword"],parameters[@"ResourceType"],parameters[@"OfflineCourseId"]];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/******************************collection course******************************/
#pragma mark - favorite course

//post favorite course
+ (void)postCollectionFavoriteWithParameters:(id)parameters
                                     success:(void(^)(id responseObject))success
                                     failure:(void(^)(NSError *error))failure {
    
    NSString *taskActionStr = @"Favorites/Set";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get favorite course list

+ (void)getFavoriteSourcesWithParameters:(id)parameters
                                 success:(void(^)(id responseObject))success
                                 failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"Favorites/Paging?Page=%@&PageSize=10",[parameters allValues].firstObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//check course favorite state

+ (void)getCheckSourceCollectedStateWithParameters:(id)parameters
                                           success:(void(^)(id responseObject))success
                                           failure:(void(^)(NSError *error))failure {
    
    NSString *sourseUrl = [NSString stringWithFormat:@"Favorites/Check?CourseId=%@",[parameters allValues].firstObject];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,sourseUrl];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**********************class group********************/
#pragma mark - class group
//get Group/List
//check course favorite state

+ (void)getClassGroupSourseWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Group/List?"];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**********************day class schedule********************/
#pragma mark - day class schedule
//get Schedule/TodayStat
+ (void)getClassDayScheduleWithParameters:(id)parameters
                                  success:(void(^)(id responseObject))success
                                  failure:(void(^)(NSError *error))failure {
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Schedule/TodayStat?"];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get ClassAndGroup DaySchedule List
+ (void)getClassAndGroupDayScheduleListWithParameters:(id)parameters
                                              success:(void(^)(id responseObject))success
                                              failure:(void(^)(NSError *error))failure {
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Schedule/List?"];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get Class Day Schedule Recentest Activity
+ (void)getClassDayScheduleRecentestActivityWithParameters:(id)parameters
                                                   success:(void(^)(id responseObject))success
                                                   failure:(void(^)(NSError *error))failure {
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"Schedule/RecentestActivity?"];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get Class DaySchedule RangeActivitys
+ (void)getClassDayScheduleRangeActivitysWithParameters:(id)parameters
                                                   success:(void(^)(id responseObject))success
                                                   failure:(void(^)(NSError *error))failure {
    NSString *paraStr = [NSString stringWithFormat:@"Schedule/RangeActivitys?StartDate=%@&EndDate=%@&FilterOldActivity=%@&FilterGroupActivity=%@",parameters[@"StartDate"],parameters[@"EndDate"],parameters[@"FilterOldActivity"],parameters[@"FilterGroupActivity"]];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,paraStr];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 获取统计报表列表
///OfflineCourse/ListGroupByYear 获取统计报表列表

+ (void)getOfflineCourseListGroupByYearWithParameters:(id)parameters
                                              success:(void(^)(id responseObject))success
                                              failure:(void(^)(NSError *error))failure {

    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,@"OfflineCourse/ListGroupByYear?"];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//OfflineCourse/Stat 获取统计报表详情

+ (void)getOfflineCourseStatisticalDetailWithParameters:(id)parameters
                                                success:(void(^)(id responseObject))success
                                                failure:(void(^)(NSError *error))failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"OfflineCourse/Stat?Id=%@",parameters[@"Id"]];
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,urlStr];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

///OfflineCourse/StudentActivityDetailGroupByMonth 按月获取统计详情

+ (void)getOfflineCourseStatisticalDetailByMonthWithParameters:(id)parameters
                                                       success:(void(^)(id responseObject))success
                                                       failure:(void(^)(NSError *error))failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"OfflineCourse/StudentActivityDetailGroupByMonth?Id=%@&StudentId=%@",parameters[@"Id"],parameters[@"StudentId"]];
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,urlStr];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/******************get sponsor students info *****************/
#pragma mark - 发起提问

///OfflineCourse/AskQuestionMemberStat 获取发起提问学生详情

+ (void)getOfflineCourseAskQuestionMemberStatWithParameters:(id)parameters
                                                    success:(void(^)(id responseObject))success
                                                    failure:(void(^)(NSError *error))failure {
    
    NSString *urlStr = [NSString stringWithFormat:@"OfflineCourse/AskQuestionMemberStat?OfflineCourseId=%@",parameters[@"OfflineCourseId"]];
    
    NSString *URL = [NSString stringWithFormat:HOST_SERVICE,urlStr];
    
    [KTMWebService getWithURL:URL parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//OfflineCourse/AskQuestionEvaluation上传教师对于学生的评价

+ (void)postOfflineCourseAskQuestionEvaluationWithParameters:(id)parameters
                                                     success:(void(^)(id responseObject))success
                                                     failure:(void(^)(NSError *error))failure {
    
    NSString *taskActionStr = @"OfflineCourse/AskQuestionEvaluation";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//OfflineCourse/AskQuestionLaunchPush 发起提问
+ (void)postOfflineCoorseSponsorQuestionWithParameters:(id)parameters
                                               success:(void(^)(id responseObject))success
                                               failure:(void(^)(NSError *error))failure {
    
    NSString *taskActionStr = @"OfflineCourse/AskQuestionLaunchPush";
    NSString *URLString = [NSString stringWithFormat:HOST_SERVICE, taskActionStr];
    
    [KTMWebService CMPostWithURL:URLString parameters:parameters sucess:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
