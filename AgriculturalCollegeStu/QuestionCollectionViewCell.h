//
//  QuestionCollectionViewCell.h
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//

typedef void(^selectedAnswerItem)(NSArray *answers);

typedef NS_ENUM(NSUInteger, TestQuestionType) {
    TestQuestionTypeSigle=1,
    TestQuestionTypeMultiple,
    TestQuestionTypeJudge,
};


#import <UIKit/UIKit.h>

@interface QuestionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSMutableDictionary *courseInfo;
@property (copy, nonatomic) selectedAnswerItem selectedAnswer;

//@property (strong, nonatomic) NSMutableArray *answerArray;
@property (assign, nonatomic) TestQuestionType QUEType;


@end
