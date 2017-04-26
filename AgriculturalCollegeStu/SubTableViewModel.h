//
//  SubTableViewModel.h
//  OldUniversity
//
//  Created by mahaomeng on 15/8/3.
//  Copyright (c) 2015年 Mahaomeng. All rights reserved.
//


@class Lecturer;

@interface SubTableViewModel : NSObject

@property (nonatomic, copy) NSString *Cover;

@property (nonatomic, copy) NSString *Period;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *SignPersonNum;

@property (nonatomic, copy) NSString *CourseType;

@property (nonatomic, copy) NSString *UpdateMessage;

@property (nonatomic, copy) NSString *CourseBeginTime;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Description;

@property (nonatomic, strong) NSDictionary *Lecturer;

@property (nonatomic, copy) NSString *parentCategoryName;

@property (nonatomic, assign) int cellType;

@property (nonatomic, assign) NSString *parentCategoryId;

@end

