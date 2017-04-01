//
//  OfflineCourseModel.h
//  xingxue_pro
//
//  Created by 张磊 on 16/5/17.
//  Copyright © 2016年 xingxuenet. All rights reserved.
//

#import "HOMEBaseModel.h"

@interface OfflineCourseModel : HOMEBaseModel

@property (retain, nonatomic) NSString *Id;
@property (retain, nonatomic) NSString *Name;
@property (retain, nonatomic) NSString *StartDate;
@property (retain, nonatomic) NSString *EndDate;
@property (retain, nonatomic) NSString *Teacher;
@property (retain, nonatomic) NSString *PlanPersonNum;
@property (retain, nonatomic) NSString *Address;
@property (retain, nonatomic) NSString *Pic;
@property (retain, nonatomic) NSString *Desc;
@property (retain, nonatomic) NSString *TeacherDescription;
@property (assign, nonatomic) NSString *IsEnd;
@property (retain, nonatomic) NSString *UserSignCount;
@property (retain, nonatomic) NSString *UserUnSignCount;
@property (retain, nonatomic) NSString *IsUserSign;

@end