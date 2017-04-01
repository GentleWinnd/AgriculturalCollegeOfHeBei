//
//  SignedStuView.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/9.
//  Copyright © 2016年 YH. All rights reserved.
//

#define SUBMIT_STU @"submitStudents"
#define SHOULD_STU @"ShouldStudents"

/**
 student Info type

 - StuInfoTypeSigne: signe
 - StuInfoTypeTest: test
 - StuInfoTypeTask: task
 - StuInfoTypeTribe: tribe
 */
typedef NS_ENUM(NSInteger, StuInfoType) {
    StuInfoTypeSigne,
    StuInfoTypeTest,
    StuInfoTypeTask,
    StuInfoTypeTribe,
};


#import <UIKit/UIKit.h>


typedef void (^selectdStu) (NSString *stuId);

@interface SignedStuView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *stuCollectionView;

@property (nonatomic, strong) NSDictionary *signedStuInfo;

@property (nonatomic, strong) NSArray *signedStuArray;

@property (nonatomic, copy) selectdStu selectedStu;

@property (nonatomic, assign) ClassAssignmentType *assignmentType;

@property (nonatomic, assign) StuInfoType stuType;

+ (instancetype)initViewLayout;

@end

@interface HeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *stuName;

@end
