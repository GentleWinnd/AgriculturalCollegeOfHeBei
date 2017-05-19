//
//  QuestionCollectionViewCell.m
//  AgriculturalCollegeStu
//
//  Created by YH on 2016/12/16.
//  Copyright © 2016年 YH. All rights reserved.
//
#define STU_SELE_ANSWER @"studentSelectedAnswers"

#define QUE_TAG 10

#import "QuestionCollectionViewCell.h"
#import "QuestionHeaderView.h"
#import "SelecteAnswerTableViewCell.h"

@interface QuestionCollectionViewCell()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *QuestionInfoTable;
@property (strong, nonatomic) NSMutableDictionary *questionInfo;

@end
static NSString *CellID = @"answerCellID";

@implementation QuestionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self initTableView];
}

- (void)setCourseInfo:(NSMutableDictionary *)courseInfo {
    
    self.QUEType = [NSString safeNumber:courseInfo[@"QuestionType"]].integerValue;
    _questionInfo = [NSMutableDictionary dictionaryWithDictionary:courseInfo];
    
    [_QuestionInfoTable reloadData];
}

- (void)initTableView {
    _QuestionInfoTable.delegate = self;
    _QuestionInfoTable.dataSource = self;
    _QuestionInfoTable.estimatedRowHeight = 20.0;
    _QuestionInfoTable.rowHeight = UITableViewAutomaticDimension;
    [_QuestionInfoTable registerNib:[UINib nibWithNibName:@"SelecteAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:CellID];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)_questionInfo[@"QuestionOptionList"]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //根据label文字获取CGRect
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //set the line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:15],
                              NSFontAttributeName,
                              paragraphStyle,
                              NSParagraphStyleAttributeName,
                              nil];
    
    //assume your maximumSize contains {250, MAXFLOAT}
    CGRect lblRect = [[NSString stringWithFormat:@"%@", self.questionInfo[@"Content"]] boundingRectWithSize:(CGSize){WIDTH - 66, MAXFLOAT}
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attrDict
                                              context:nil];
    return lblRect.size.height+12;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSString *SELItem = @"";
//    for (NSDictionary *AnInfo in self.answerArray) {
//        for (NSDictionary *questionInfo in self.questionInfo[@"QuestionOptionList"]) {
//            if ([AnInfo[@"Id"] isEqualToString:questionInfo[@"Id"]]) {
//                SELItem = [NSString stringWithFormat:@"%@%@",SELItem,questionInfo[@"ABCorderNum"]];
//                break;
//            }
//        }
//    }
//
    QuestionHeaderView *gradeView = [[NSBundle mainBundle] loadNibNamed:@"QuestionHeaderView" owner:nil options:nil].lastObject;
    gradeView.question.text = [NSString stringWithFormat:@"%@", self.questionInfo[@"Content"]];
    gradeView.type = [self.questionInfo[@"QuestionType"] integerValue];
    self.QUEType = [self.questionInfo[@"QuestionType"] integerValue];
    gradeView.tag = QUE_TAG;
    return gradeView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelecteAnswerTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
   
    NSDictionary *optionsInfo = [NSDictionary safeDictionary:_questionInfo[@"QuestionOptionList"][indexPath.row]];
    NSString *coderNum = self.QUEType == TestQuestionTypeJudge ?[NSString safeString:optionsInfo[@"Content"]]: [NSString safeString:optionsInfo[@"ABCorderNum"]];
    NSString *contentStr = self.QUEType == TestQuestionTypeJudge ?@"  ":[NSString safeString:optionsInfo[@"Content"]];
    cell.selecteItem.text = coderNum;
    cell.selecteAnswer.text = contentStr;
    cell.selecteItem.layer.backgroundColor = [UIColor whiteColor].CGColor;
    cell.selecteItem.textColor = MainTextColor_DarkBlack;
    NSArray *answerArray = [NSArray safeArray:[self getAnswerSelectedtOptionId:_questionInfo[@"LastStudentAnswer"]]];
    for (NSString *selectedId in answerArray) {
        if ([optionsInfo[@"Id"] isEqualToString:selectedId]) {
            cell.selecteItem.layer.backgroundColor = MainThemeColor_Blue.CGColor;
            cell.selecteItem.textColor = [UIColor whiteColor];
        }
    }
    UIView *backView = [[UIView alloc]initWithFrame:cell.bounds];
    backView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = backView;
    
    NSString *lastAnswer = [NSString safeString:_questionInfo[@"LastStudentAnswer"]];
    cell.userInteractionEnabled = lastAnswer.length>0?NO:YES;
   
    return cell;
}

- (NSArray *)getAnswerSelectedtOptionId:(NSString *)optionId {
    NSMutableArray *finishedArray = [NSMutableArray arrayWithArray:[NSArray safeArray:[optionId componentsSeparatedByString:@","]]];
    
    NSArray *answerArray = [NSArray safeArray:self.questionInfo[STU_SELE_ANSWER]];

    for (NSDictionary *itemInfo in answerArray) {
        [finishedArray addObject:itemInfo[@"Id"]];
    }
    
    return finishedArray;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    NSString *answerId = self.questionInfo[@"QuestionOptionList"][indexPath.row][@"Id"];
    NSString *answerItem = self.questionInfo[@"QuestionOptionList"][indexPath.row][@"ABCorderNum"];
    NSString *contentStr = self.questionInfo[@"QuestionOptionList"][indexPath.row][@"Content"];

    NSMutableArray *ansArr = [NSMutableArray arrayWithArray:self.questionInfo[STU_SELE_ANSWER]];
    
    /*
     {
     "Id": "ddb0b2bf-e4ae-4372-a3e1-3ac37853892d",
     "ABCorderNum": "A",
     "Content": "1",
     "OrderNum": 1
     },
     */
    NSDictionary *anInfo;
    
    if (self.QUEType == TestQuestionTypeJudge) {
        anInfo = @{@"Item":contentStr,
                   @"Id":answerId};
    } else {
        anInfo = @{@"Item":answerItem,
                   @"Id":answerId};
    }

    if (ansArr.count == 0) {
        [ansArr addObject:anInfo];
    } else {
    
        if (self.QUEType == TestQuestionTypeSigle || self.QUEType == TestQuestionTypeJudge) {//单选
            [ansArr replaceObjectAtIndex:0 withObject:anInfo];
        } else if (self.QUEType == TestQuestionTypeMultiple) {//多选
            NSInteger index=0;
            NSArray *arr = [NSArray arrayWithArray:ansArr];
            for (NSDictionary *itemINfo in arr) {
                if (![itemINfo[@"Id"] isEqualToString:answerId]) {
                    [ansArr addObject:anInfo];
                } else {
                    [ansArr removeObject:itemINfo];
                }
                index++;
            }

    }
   //    NSString *SELItem = @"";
//    for (NSDictionary *AnInfo in self.answerArray) {
//        for (NSDictionary *questionInfo in self.questionInfo[@"QuestionOptionList"]) {
//            if ([AnInfo[@"Id"] isEqualToString:questionInfo[@"Id"]]) {
//                SELItem = [NSString stringWithFormat:@"%@%@",SELItem,questionInfo[@"ABCorderNum"]];
//                break;
//            }
//        }
//    }
//    
    
//    QuestionHeaderView *headerView = [_QuestionInfoTable viewWithTag:QUE_TAG];
//    headerView.question.text = [NSString stringWithFormat:@"%@(%@)",self.questionInfo[@"Content"],SELItem];
    }
    
    [self.questionInfo setValue:ansArr forKey:STU_SELE_ANSWER];
    [tableView reloadData];
    
    self.selectedAnswer(ansArr);
  
}






@end
